---
title: Argyle
subtitle: An offline collection of online tools
date: 2021-01-01
tags:
    - vuejs
    - nuxt
    - hackathon
    - encryption
---

This was my submission for the [DEV.to DigitalOcean Hackathon](https://dev.to/devteam/announcing-the-digitalocean-app-platform-hackathon-on-dev-2i1k).

## What I built
Argyle, an offline collection of online tools.

### Category Submission: 
Program for the People

### App Link
[Custom Domain](https://argyle.geopjr.dev/)

### Screenshots
![screenshot of Argyle's main page](https://i.imgur.com/5cjMyoo.png)

### Description
 Argyle is a Vue web app + PWA that provides **42** (public) tools as for now. Tools are split in 8 categories: text, beautify, minify, encryption, compilers, gaming, time and other.

### Link to Source Code
https://github.com/GeopJr/argyle


## Background
I often find myself wanting to do basic actions, like encrypting text with AES, when I'm away from my workstation. Usually, the first thing I do is search for an *online* tool. However, most, if not all, require an online connection (duh!) and execute your request on their server. This brings up a huge risk, **privacy**. With Argyle I wanted to overcome those, I wanted to feel secure when using a web tool, that's why Argyle executes everything **client-side**. Most of the tools don't even require an internet connection, allowing you to run it **offline** (hey! it also comes with a **PWA**)!

### How I built it 
Argyle uses Vue with Nuxt, allowing it to be a SPA without any hustle. This was the first time I made a PWA and I'm quite surprised with how easy it was!
Initially I wanted to use DO app platform to serve it as static (since I already have a GitHub action that builds and pushes to gh-pages branch), but it didn't play well with the routes so I went with serving it using `nuxt start`.

### Additional Resources/Info
DO app platform makes deploying web apps (especially non-static ones) super easy!
