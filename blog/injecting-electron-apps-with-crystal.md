---
title: Injecting electron apps with Crystal
date: 2020-10-13
tags:
    - crystal
    - electron
hidden: true
---

The need for (FOSS) desktop apps is getting larger each year for all platforms. There are many tools that allow you to build apps, but only a few have multi-platform support. One of the most popular ones is Electron, a framework maintained by GitHub which allows developers to write apps using web technologies. While Electron has many disadvantages (mainly performance and theme wise), it also holds the app's source in a simple archive, asar. This allows us to view and edit it's source (even though it's probably against their TOS).

# [Asar](https://github.com/electron/asar)

> Asar is a simple extensive archive format, it works like tar that concatenates all files together without compression, while having random access support.
~ https://github.com/electron/asar/blob/master/README.md

Asar consists of 2 things:

- A header
- All file contents combined

The header is a structured JSON that includes info about the files that are going to be archived. A basic header would be:
```json
{
   "files": {
      "home": {
         "files": {
           "hosts": {
             "link": "/etc/hosts",
           }
         }
      },
      "etc": {
         "files": {
           "hosts": {
             "offset": "0",
             "size": 32,
             "executable": false
           }
         }
      }
   }
}
```

From the above example we can see that folders must have a `files` key, symlinks must have a `link` key pointing to the location of the actual file relative to the root of the archive and lastly, files must have a `size` and `offset` key (`executable` is optional).

`size` is the size of the file, while `offset` is the offset of the archive. (eg. The next file should have an offset of 32). Offset is `UINT64` but can also be represented as a String.

## The problem

Since my language of choice is Crystal, I have to declare the type of each key and value which is impossible since the input is unknown. Crystal has many shards, one of which is Petoem's asar 

https://github.com/petoem/asar

however it can only read and cache files. My solution was to use a recursive hash `alias HeaderData = Hash(String, HeaderData) | String | UInt64` (and create my own shard based on Petoem's, which allows extracting and packing). 

https://github.com/GeopJr/asar-cr

Ok, back to asar.

## Packing

Now that we have created our header (by looping through all the files and adding them to the hash based on what they are, while also reading their size and adding to an offset for the next one) and combined all file contents into a long string or IO, it's time to build our archive.

The archive is very flat, as mentioned in their readme:

`| UInt32: header_size | String: header | Bytes: file1 | ... | Bytes: file42 |`

This gets calculated here: https://github.com/GeopJr/asar-cr/blob/master/src/asar-cr/pack.cr#L62-L74

To create the archive I create a new IO where I push the above header, the header we created previously and last but not least, the file contents. Then I write this IO into a file.

## Unpacking

Unpacking is basically the above in reverse. We read the header and create each file depending on its type (directory, symlink or file).

# Injecting Electron apps

For this example I will use Discord. Keep in mind that Discord specifically claims that modifying the client is against their TOS.

Discord's core.asar on Linux is located at `~/.config/discord(ptb/canary)/modules/discord_desktop_core/core.asar`

Using my shard (mentioned above), all we need to do is
```cr
require "asar-cr"

asar = Asar::Extract.new "~/.config/discord/modules/discord_desktop_core/core.asar"

asar.extract "~/.config/discord/modules/discord_desktop_core/core_unpacked"
```

We can then manually edit any files we want.
After we are done, it's time to pack it.

! Remember to take backups of core.asar just in case something goes wrong !

```cr
require "asar-cr"

asar = Asar::Pack.new "~/.config/discord/modules/discord_desktop_core/core_unpacked"

asar.pack "~/.config/discord/modules/discord_desktop_core/core.asar"
```

And we are done! You can now restart Discord and see your edits in action!

# Writing tools

You can also write tools that will automate the above process. I wrote [Crycord](https://crycord.geopjr.dev/)

which offers a modular way to modify your client. Some of the plugins are real-time CSS injection and unrestricted resize. (Also searches for both the native and flatpak version).