---
title: "Snap: The Good, the Bad and the Ugly"
subtitle: From an app developer perspective
date: 2024-01-29
updated: 2024-09-20
hidden: true # don't want to keep track of its progress nor misinform anyone
tags:
    - linux
---

:::Update 2024-09-20
As of 2024-09-18, I managed to push the Tuba snap to 0.8.4. Even after the required libraries had landed, they were behind a flag which made it impossible to build on Snapcraft's servers (or at least that's what I gathered from the person that was moving this forward). GNOME 47 is out now and the next Tuba release will depend on libadwaita 1.6. I doubt it will land in time on Snap :/

Libadwaita 1.6 introduced accent colors too, only time will tell if the Snap libadwaita patch is going to be removed.
:::

Ten months ago, I was asked to package Tuba into a Snap. Being unfamiliar with it my initial thought was to decline but knowing how difficult it is to work with some package maintainers - especially if it would make it into the store of one of the most popular distributions - I decided to give it a try. This is my experience with it.

Let me preface this by saying that this is not about Canonical, whether parts of it are proprietary, its dependencies, size etc. This is purely from a developer standpoint. I'll be happy to edit this post if parts of it are wrong, please contact me.

# The Good

## Documentation

The snapcraft team has excellent documentation and tutorials for almost everything, from GTK 2 to .NET. You'll find a step-by-step guide, from metadata to building & publishing it. Seriously, the quality is astonishing, check it out for yourself: https://snapcraft.io/docs

## Plugins

Have you ever tried to create a Flatpak for a Flutter app or an app that uses unpopular technologies? Let me tell you... it's not great. It usually involves extracting a pre-built package, or if you really want to build it from source, you might have to install the whole stack and their dependencies *and* keep everything up-to-date yourself.

On the Snap side of things, plugins take care of almost everything, you don't have to care about versioning dependencies yourself or setting up a proper build environment for many obscure or difficult-to-work-with technologies (yes, even Crystal).

## Tooling

`snapcraft` is extremely easy to use. All you have to do is run `snapcraft` and soon enough, you'll have a `<name>.snap` package you can install and share. You don't have to look up how to output it in a shareable format, what arguments to provide or why there's now a random folder clogging your repo.

## Store

Detailed metrics for currently active users are very helpful. You can see at any point in time which versions have been more popular, how often your users update and from which countries they are from.

![A graph of the weekly active devices for the past 30 days for Tuba as seen on the metrics page on snapcraft]({{GEOPJR_BLOG_ASSETS}}/1.webp)

It also hosts your apps' screenshots which I've come to really appreciate after I had to move away from imgur ever since I was notified that it's blocked in some countries.

<figure>
  <img src="{{GEOPJR_EMOTES_!}}" alt="" class="emote pixelated" />
  <figcaption>FYI, linux distros have a <b>really</b> hard time dealing with git-lfs</figcaption>
</figure>

# The Bad and the Ugly

Let me get this out of the way:

## Portals & Sandbox

If you search `snap xdg desktop portal`, one of the top results will be [my post in the forums](https://forum.snapcraft.io/t/doesnt-use-the-xdg-desktop-portal/34360). The gist was that my app (Tuba) wouldn't use the portal to get a file and the only log I had was a cryptic AppArmor denial. I received some instructions on further debugging it and some suggestions but nothing really worked. Then I received one reply that blew my mind: (No offense to the person who posted it, they were actually the only person who cared enough even months after my post and sent a few PRs)

> Man if your apps needs the access of home folder, you must give it na!
> 
> Add the home plug.

That's right, since the portal doesn't work from Snap's side, the solution is to just open a hole in the sandbox... This would never fly on Flathub (unless the app doesn't support portals). What's the point of a sandboxed environment if the moment something doesn't work, the solution is to just open a hole in it?

<img src="{{GEOPJR_EMOTES_X}}" alt="" class="emote pixelated" />

Snap developers were tagged, and after more debugging, nothing came of it. The replies slowed down to 2 per 1–3 months. Until GTK added FileDialog and fixed it. This was the biggest disappointment I had with Snap, it's difficult to compare it to Flatpak when the second one of the key benefits (sandboxing) has issues, the solution is to disable it.

## Support

As described above, support is clearly lacking. Two Snap developers (or at least team members) were tagged, and only one replied with debugging instructions twice. I'm sure they had other stuff to do, but I honestly don't even know if they read my replies to them. Testing the Snap themselves would also have been far more insightful instead of trying to async debug it through me - someone who is not experienced with Snaps. Which brings me to my next point:

## Reproducible environment

Are Snaps even host-independent? I wasn't sure from the start. I knew they depend(ed?) on a specific AppArmor version found on Ubuntu (hence why I was testing in a VM) but is that all?

Here's an issue I received: [snap nightly does not connect to any instance (time out)](https://github.com/GeopJr/Tuba/issues/210). I can't reproduce it. I can't reproduce it on my machine; I can't reproduce it on an Ubuntu VM; I can't reproduce it on a live image; I just can't. How do I even debug this without asking the user to run a bunch of random debug commands that were suggested to me previously? Sure, it's network related, but since the Snap has the required permissions, why does it differ from the host? 🤷

<img src="{{GEOPJR_EMOTES_?}}" alt="" class="emote pixelated" />

To this day, I don't think I've ever come across a Flatpak bug that I couldn't reproduce on my machine (except some font related ones).

## GNOME SDK

I've seen multiple times Spotify being mentioned as one of the reasons Snap is widely used. I don't doubt that. Now imagine if the SDK Spotify uses shipped a modified version of their libraries or a modification that injected CSS that changes their beloved green accent to orange. Do you think Spotify would stay? No.

<figure>
  <img src="{{GEOPJR_EMOTES_X}}" alt="" class="emote pixelated" />
  <figcaption>More like "Ubuntu" SDK</figcaption>
</figure>

Somehow, that's totally appropriate for GNOME apps. The "GNOME" SDK includes an **1101-line** libadwaita patch that enables Yaru accent colors, among other things. I'm not targeting Ubuntu, I'm not testing on Ubuntu and the Snap team definitely does not test my app. So what's the point of shipping a patch that can (and does when certain accent colors are used) break my app that nobody will help me fix, as shown previously? Again, I'm targeting GNOME, not Ubuntu. Why is it okay to break my app for the sake of your **own** branding? Just split them into a GNOME and an Ubuntu SDK; otherwise, you won't see many GNOME apps in the store published by their developers.

<figure>
  <img src="{{GEOPJR_BLOG_ASSETS}}/2.webp" alt="A poll on Tuba under Ubuntu using the green/grey accent color. The poll result is not that clear on the winning choice as its a small grey text on grey/green background" />
  <figcaption>This is why we need named accent colors by the way</figcaption>
</figure>

Additionally, the GNOME SDK is not always up-to-date. The current stable one is "42" (it's actually 45, but it never changed names). When libadwaita 1.4 had yet to be released, there wasn't a beta SDK, I couldn't test my app, and I had to disable my CI, which resulted in a late Snap release. From what I can see, however, the 46 one is in the works, which is nice!

Lastly, the SDK itself is not perfect. [It needs additional cleaning up](https://github.com/GeopJr/Tuba/pull/93) and even though it doesn't support s390x and ppc64el, it tries to build them by default:

![Screenshot of the Tuba's Builds tab on snapcraft. It shows the last runs in a list for every arch. The s390x and ppc64el failed.]({{GEOPJR_BLOG_ASSETS}}/3.webp)

## Verification

Flatpak introduced app verifications some time ago. It allows you to verify that an app was published by its developer using the app ID and DNS. Snap doesn't work that way. Typical verifications are reserved for organizations and companies:

> [Verified Publisher status is for Snap authors that have worked, collaborated or partnered with us as part of an institution, foundation or company. If you are an individual publisher that has maintained a number of Snaps or been active in the community, you can apply to be a Star Developer](https://forum.snapcraft.io/t/verified-accounts/34002)

Star Developers on the other hand are... anyone trusted in the community.

Unless someone already knows that the checkmark and the star badges are meant to convey something *very* different, chances are they are going to think that "Star Developers" are also the app developers. Flatpak goes to great lengths to make sure this doesn't happen. The submission template asks you to provide proof that you are allowed to publish a third-party app.

There are so many apps on the store by Star Developers that even I, someone who knows that they are not verified, subconsciously treat them as such. And honestly, I cannot see the point of this. Why aren't individual developers allowed to verify themselves? Why are trusted community members treated more highly than the actual app developers? I trust an app's authors 100% more than community members to know what their app needs.

<figure>
  <img src="{{GEOPJR_BLOG_ASSETS}}/4.webp" alt="Screenshot of the snapcraft main page showing 3 apps. Beekeeper Studio by BEEKEEPER STUDIO (no icon next to the name), Sublime Text by SNAPCRAFTERS (star icon next to the name), pycharm-community by JETBRAINS (checkmark next to the name)" />
  <figcaption>Beekeeper Studio by Beekeeper Studio does not have a checkmark <b>but</b> unofficially packaged Sublime Text by Snapcrafters does have a star</figcaption>
</figure>

# Conclusion

This has been my experience with Snap so far. I gave it an honest try and really wanted it to succeed, but I also need my app to be perfect. The Snap package still does not have feature parity with the Flatpak one due to missing the spell-checking languages, and the only solution I found was opening a hole in the sandbox... Ultimately, I don't think I can provide support for Snap packages of my apps or promote them as "Official".
