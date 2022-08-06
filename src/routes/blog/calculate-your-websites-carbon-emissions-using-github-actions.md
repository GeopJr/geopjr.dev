---
title: Calculate your website's Carbon emissions
subtitle: using GitHub Actions
date: 2021-12-07
tags:
    - github
    - javascript
    - docker
    - hackathon
---

This was my submission for the [DEV.to GitHub Actions 2 Hackathon](https://dev.to/devteam/announcing-the-github-actions-hackathon-on-dev-3ljn).

In a world where people are willing to destroy our (only) planet for profit without providing something in return (looking at you NFTs 👀), we, as developers, are responsible for the sustainability of what we create or contribute to.

> “If the Internet was a country, it would be the 7th largest polluter”
~ [Sustainable Web Manifesto](https://www.sustainablewebmanifesto.com/)

There are at least three parts on reducing your website's carbon emissions: Host, Code & Content.

- Host: Hosting your website on a host that uses renewable energy can decrease its CO2 emissions significantly. [The Green Web Foundation](https://www.thegreenwebfoundation.org/) has collected a huge list of them. Additionally, it has created many tools utilizing them, including the [Green Web Check](https://www.thegreenwebfoundation.org/green-web-check/) tool.

- Code: In the vast ocean of JavaScript frameworks, we've seen many tools raise (and fall), some "heavier" and "slower" than others. The bigger bundles a framework creates, the more CO2 emissions the website produces per view. A quite thorough [analysis](https://dev.to/this-is-learning/javascript-framework-todomvc-size-comparison-504f) was done by the creator of Solid here on DEV. But the results were similar enough for the choice of framework to be insignificant. A better tip would be writing clean code and minimizing the amount of JavaScript used.

- Content: Images are the biggest offenders to the amount of data clients need to download when visiting a website. Compressing them, reducing the amount used and replacing them with SVGs (if possible of course) will all contribute against it. After that, ADs, tracking, other media (eg. sounds & videos) and fonts increase the total data transferred by a lot.

On the action side of things, the action uses lighthouse to get the amount of transferred data which then passes through some calculations to get the amount of CO2 it produces per visit. The Green Web Foundation's API is also used (if set to true) to determine whether the host is using renewable energy. Lastly, some additional calculations are being done to generate some fun facts about it before logging it in the action output & create comments on the commit or PR that caused it to run. This all happens inside a docker container for two reasons: 1) GitHub uses at max node12 (Current LTS is 16) plus dependencies are being bundled in the repo (which increases its size and makes development difficult). 2) lighthouse requires a browser to run which is far easier and less time consuming to just install in the docker image.

### My Workflow
```yaml
name: Calculate CO2 🌱
on: [push, pull_request]

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - name: Calculate CO2 🌱
        uses: GeopJr/CO2@v1
        with:
          url: "https://geopjr.dev/"
          renewable: true
```

### Submission Category: 

Maintainer Must-Haves

> Reasoning: Reducing your website's carbon emissions is just as important as running tests. Accepting a PR or commiting code that increases them by eg. 20% is irresponsible and should be prevented as soon as possible.

### Yaml File or Link to Code

https://github.com/GeopJr/CO2

### Additional Resources / Info

[Marketplace](https://github.com/marketplace/actions/co2-ci)

You can see it in action on the repo: on a [PR](https://github.com/GeopJr/CO2/pull/2#commitcomment-61310536), a [commit](https://github.com/GeopJr/CO2/commit/723100e21908cb59d76a42666b7125221dca6f90#commitcomment-61310536) or an [action log](https://github.com/GeopJr/CO2/runs/4409513694?check_suite_focus=true).

The repo README includes workflows for connecting Vercel & Netlify previews with the action as well as some interesting action conditions.

This whole action is heavily inspired by the [Website Carbon Calculator](https://www.websitecarbon.com/) by [Wholegrain Digital](https://www.wholegraindigital.com/).

The renewable energy check is being done by [The Green Web Foundation](https://www.thegreenwebfoundation.org/).

Take action: [Switch to a green host](https://www.wholegraindigital.com/blog/choose-a-green-web-host/) | [Make your website more efficient](https://www.wholegraindigital.com/blog/website-energy-efficiency/) | [Plant trees to reduce your carbon impact](https://treesforlife.org.uk/support/for-businesses/carbon-offsetting/)

### Screenshot

![pull request comment/review with the result of CO2](https://i.imgur.com/HiI2yCv.png)
