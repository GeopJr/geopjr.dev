---
title: Packaging your Crystal app into a Flatpak
date: 2021-05-23
updated: 2022-08-06
tags:
    - crystal
    - gnome
---

# Edit

You should really take a look at the [Ultimate GTK4 Crystal Guide](ultimate-gtk4-crystal-guide.geopjr.dev/) instead.

A guide that will teach you how to make GTK4 apps with Crystal covering everything from UI to I18N.

The original post will be kept for archival reasons, you really shouldn't follow it.

# Original

Crystal has proven itself multiple times on how versatile and flexible it is, from web to desktop applications.

When building Desktop Applications, you will soon find yourself into a dilemma on how to distribute it. One way would be to just upload a crystal compiled binary and call it a day. But you will soon realize that binaries alone are not... that great for desktop apps. Auto-updates, launchers, icons and dependencies are some of the features we've come to expect today. So what are your other options?

- OS specific packages (deb, rpm etc.)
- Appimage
- Flatpak or Snap (sandboxed)

On this post, we are going to focus on Flatpak. [Flatpak](https://flatpak.org/) is a technology that aims to solve some of the issues that modern package systems have:
- Non-distro-specific packages (you only need to install `flatpak`) 
- Sandbox
- Handle dependencies
- Stability

### Before we begin

This is based on my experience and workflow on distributing [Hashbrown](https://hashbrown.geopjr.dev/) using Flatpak. It might not be ideal.

https://github.com/GeopJr/Collision

This will also focus on building from source rather than repackaging a binary.

# Let's get started

There are two files needed:
- [applicationID].yaml (the flatpak config)
- [applicationID].metainfo.xml (metadata for the stores)

You can find more about choosing the correct application ID on the [flatpak docs](https://docs.flatpak.org/en/latest/conventions.html#application-ids).

The metainfo file should be on your repo and it contains info that will be shown on stores like flathub web, GNOME-software and KDE Discover. Description, screenshots, releases, ratings etc. You can see [Hashbrown's metainfo](https://raw.githubusercontent.com/GeopJr/Hashbrown/main/extra/dev.geopjr.Hashbrown.metainfo.xml) for an example.

# Flatpak Config

It will be easier if we go through Hashbrown's rather than a template since it's made for use with Crystal.

```yaml
app-id: dev.geopjr.Hashbrown
runtime: org.gnome.Platform
runtime-version: "3.38"
sdk: org.gnome.Sdk
command: hashbrown
finish-args:
  - --socket=wayland
  - --socket=fallback-x11
  - --share=ipc

cleanup:
  - /include
  - /lib/pkgconfig
  - /share/doc
  - /share/man
  - "*.a"
  - "*.la"

modules:
  - name: libevent
    sources:
      - type: git
        url: https://github.com/libevent/libevent.git
        tag: release-2.1.12-stable

  - name: hashbrown
    buildsystem: simple
    build-commands:
      - $(pwd)/crystal/bin/crystal build ./src/hashbrown.cr --no-debug --release
      - install -D -m 0755 hashbrown /app/bin/hashbrown
      - install -D -m 0644 extra/Hashbrown.desktop /app/share/applications/dev.geopjr.Hashbrown.desktop
      - install -D -m 0644 extra/icons/logo.svg /app/share/icons/hicolor/scalable/apps/dev.geopjr.Hashbrown.svg
      - install -D -m 0644 extra/icons/symbolic.svg /app/share/icons/hicolor/symbolic/apps/dev.geopjr.Hashbrown-symbolic.svg
    post-install:
      - install -D -m 0644 extra/dev.geopjr.Hashbrown.metainfo.xml /app/share/metainfo/dev.geopjr.Hashbrown.metainfo.xml
    sources:
      - type: git
        url: https://github.com/GeopJr/Hashbrown.git
        tag: v1.2.0
        commit: 02ecf5cc5aacc32fc484fd9e348d2b1220168295
      - type: archive
        dest: crystal/
        url: https://github.com/crystal-lang/crystal/releases/download/1.0.0/crystal-1.0.0-1-linux-x86_64.tar.gz
        sha256: 00211ca77758e99210ec40b8c5517b086d2ff9909e089400f6d847a95e5689a4
      - type: git
        url: https://github.com/jhass/crystal-gobject.git
        commit: 6468c57f8aa54b71c766d27b1e59e87a09ee8552
        dest: lib/gobject
      - type: git
        url: https://github.com/elorest/compiled_license.git
        tag: v0.1.3
        commit: f287c2c8c95579688fa5620df954d8cc1272cbbf
        dest: lib/compiled_license
```

- `runtime`, `runtime-version`, `sdk` depend on your dependencies. Since I needed gobject, I went with GNOME's.

- `finish-args` is a list of additional parameters, mostly used for setting the sandbox permissions. Always aim for the least amount of permissions. Apart from giving access to (parts of) the filesystem, flatpak supports portals. For example, as you can see, Hashbrown doesn't require any filesystem permissions, this is due to the use of GtkFileChooserNative. (As a side note, one of the biggest critisism on flatpak/flathub is that many of the apps have way too many permissions, making the sandbox useless, this is what portals are trying to solve).

- `modules` is a list of all the modules needed by the build process. First of all, we need to build libevent (needed by Crystal):
```yaml
- name: libevent
    sources:
      - type: git
        url: https://github.com/libevent/libevent.git
        tag: release-2.1.12-stable
```
Now we need to build our app. `build-commands` will include the commands needed to build and install your app. The /app folder in the sandbox equals to /usr. In my case I need to install the icons and launcher in the correct folders so the DE can access them.
The difficult part is the sources. In the building environment you can't download external files, including crystal & shards(libs), so we need to specify them manually. Thankfully in my case, none of the shards I use had external libs or post-install scripts, so I didn't need to do much other than add them.
But I wrote a tiny script that reads your shard.lock and generates the list for you (plus includes the command needed to create the symlinks). Keep in mind that if your shards have post-install scripts or need additional configuration, you will have to either collect the post-install scripts and run them in build-commands or ship a binary rather than building from source. (The path variable can be changed, in case you don't want them in current dir).
```crystal
require "yaml"

PATH = "lib"

lockfile = YAML.parse(File.read("shard.lock"))

shards = lockfile["shards"]

sources = [] of Hash(String, String)

shards.as_h.each do |x, y|
  version_type = "tag"
  version = y["version"].to_s
  if version.includes?("+git.commit.")
    version_type = "commit"
    version = version.split("+git.commit.")[-1]
  end
  sources << {
    "type"       => "git",
    "url"        => y["git"].to_s,
    version_type => version,
    "dest"       => PATH + "/" + x.to_s,
  }
end

# The following loop will go through all libs and symlink their libs to the parent folder.
puts "Place the following snippet inside the 'build-commands' of your config:"
puts "- for i in ./#{PATH}/*/; do ln -snf \"..\" \"$i/lib\"; done"
puts ""
puts "Place the following snippet inside the 'sources' of your config:"
puts sources.to_yaml
```

#### Resources
- https://docs.flatpak.org/en/latest/available-runtimes.html
- https://docs.flatpak.org/en/latest/sandbox-permissions-reference.html
- https://docs.flatpak.org/en/latest/desktop-integration.html#portals
- https://docs.flatpak.org/en/latest/manifests.html#cleanup
- https://docs.flatpak.org/en/latest/manifests.html#modules

# Building

Only one command is needed:
`flatpak-builder ./build ./<applicationID>.yaml --force-clean --install --user`

flatpak-builder keeps cache so you don't need to download runtimes and sources everytime. If the build is successful, the flatpak will be installed and you will be able to find it in your app launcher. You might need to uninstall it before re-running the command using `flatpak remove <applicationID>`.

# Publishing to Flathub

Flathub is the biggest repo for flatpaks, however you can totally host your own if you want to. Flathub has some additional requirements that you need to pass. You can find all of them on [their wiki](https://github.com/flathub/flathub/wiki). All you need to do afterwards is just make a PR and wait for it to be reviewed.

# And that's all!
It would be nice to see some Crystal apps on flathub (I believe Hashbrown is the only one at the moment). A crystal sdk (like [rust's](https://github.com/flathub/org.freedesktop.Sdk.Extension.rust-stable)) and a shard [builder tool](https://github.com/flatpak/flatpak-builder-tools) to generate the shards automatically would greatly improve the experience, if anyone is up to doing them.
