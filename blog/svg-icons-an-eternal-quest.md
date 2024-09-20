---
title: SVG Icons on the Web
subtitle: The end of an eternal quest
date: 2024-09-20
tags:
    - crystal
    - svelte
---

The website you are currently reading this on, has had more iterations than Google has had messaging apps. That's because I've never been satisfied with the stack it uses. The previous iteration used SvelteKit and while I was very pleased with it, it all went downhill when I noticed the mess SVG icons created.

# Approaches to SVG Icons and their disadvantages

Just like with images, websites that feature a lot of SVG icons, need to make sure they are cached. That way users don't re-download MBs of SVG icons for no reason every time they visit a website or navigate through its pages.

<figure>
  <img src="{{GEOPJR_EMOTES_X}}" alt="" class="emote pixelated" />
  <figcaption>Icons being visible is essential for a good user experience and far more important than MBs of JS boilerplate. Minimizing their data transfer impact is important, especially for users in metered connections.</figcaption>
</figure>

At the same time, SVGs are more than just images. Their ability to be selected from CSS allows them to change colors, styles, filters etc.

There are at least five ways to add SVG icons to a website, each with its own disadvantages:

- `<img />`

IMG elements can easily display SVG icons and cache them, but the SVGs then lose their abilities. SVG icons should be treated as bitmaps at this point. This approach however, is the most appropriate one if you are displaying full-color SVGs and don't care about re-coloring them or selecting their individual elements using CSS.

Here's Collision's icon in an IMG element:

<img src="/assets/icons/collision.svg" style="width:256px" alt="Collision's logo" />

- Embedding in HTML

SVGs are valid HTML, so you can just paste them in your HTML file. For starters, it makes maintaining the SVGs a bit difficult, unless a pre-processor embeds them automatically. The main issue is caching, while the whole page can be cached by the browser, if the same icon is used in multiple different ones, each one will transfer a copy of it, and if the HTML is not static then browser cache is a bit meaningless.

Here's Vala's logo embedded in this post:

<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" width="48" height="48"><title>Vala's logo</title><path fill="currentColor" d="m9.3836 23.9993-.5152-21.859q-2.2504.8435-3.5153 2.64-1.2509 1.7971-1.2509 4.4689 0 .6092.0629 1.0002.0776.3748.156.6092.0783.2188.1411.3438.0777.1249.0777.2188-.828 0-1.4682-.156-.641-.1723-1.0786-.5316-.4222-.3585-.6565-.9529-.2188-.593-.2188-1.4682 0-1.0624.4524-2.0937.4687-1.0306 1.2657-1.9532.8125-.9211 1.891-1.7025 1.0942-.7815 2.328-1.344Q8.3044.6409 9.6484.3289 11.0079 0 12.3519 0q.3593 0 .6565.0155.312.0156.624.0466l.2816 19.687L20.6481.1554h2.2341L13.9924 24H9.3829Z"/></svg>

> Notice that it follows the text color between light and dark mode.

- SVG Sprites

Somewhat forgotten, SVG Sprites offer a unique approach to this issue by caching a big SVG image with all the icons and then anchoring to them in your HTML. That not only allows to select them using CSS, but also to split them into smaller bundles. You can have one sprite for the icons used in the home page, one for the contact page, one for the footer etc. The main disadvantages are that if you need only one icon, you still need to download the whole sprite that has all of them, creating sprites is a bit tedious (but can be done programmatically, assuming all the icons are sprite-ready (some SVG features like gradients might need additional fixes)) and last but not least, their cache will be invalidated if you change any icon in the bundle.

Here's Vala's logo as a sprite:

<svg height="2.4em" width="2.4em">
  <title>Vala's logo</title>
  <use xlink:href="/assets/icons/vala.svg#vala"></use>
</svg>

> By inspecting it, you'll see the actual icon from the sprite being embedded in a shadow root

- Font

I've only had the displeasure of using custom font files for icons once in the past. While they are cached, they are difficult to work with and only support font related styles. On the plus side however, using them in text is awesome compared to the other solutions as they can automatically wrap and follow the style of the rest of the text. The biggest problem is that fonts is one of those things you can't really expect to be available. Users and browsers can override or even disable custom fonts. This is not a special case, it's very common, especially for accessibility reasons, performance or privacy. Lastly, the cache gets invalidated any time the font file changes.

- JavaScript

Yes, it's possible and it's actually one of the best solutions. Creating small JS files for each svg that automatically replace a placeholder with the SVG element on load fixes all the issues discussed so far. Browsers cache JavaScript, so each file will be individually cached. The SVG gets added in the DOM so CSS works. Plus you can modify them in runtime, right before they get added. The catch? JavaScript is one of the first thing users disable if they are using low performance devices or metered connections. Additionally, bundlers are very likely to mess this up and bundle everything together.

# My issues with icons in Svelte

I haven't been following Svelte(Kit)'s progress, so I don't know if this is still an issue or there are workarounds. This was just my tipping point that made me switch to the current solution.

One of Svelte's selling points is about how it cleverly optimizes the exported bundle, leading to smaller sizes among other things. However the bundle size is always relative to the source, by design.

E.g. let's take a look at the [hello world example](https://svelte.dev/repl/hello-world)'s "JS Output" tab. There are 45 lines of code. That's small (ignoring the dependencies), especially compared to the alternatives. But shouldn't the compiler detect that 'name' is a static string and generate nothing?

Now let me make it clearer, replace everything on the `App.svelte` side with `<h1>Hello!</h1>`. A static HTML element, right? Let's go back to the 'JS Output' tab... 45 lines again?!?!?

As you've probably noticed now, Svelte will re-construct the DOM in JavaScript, no matter if it's completely static or compiles to something static.

<figure>
  <img src="{{GEOPJR_EMOTES_!}}" alt="" class="emote pixelated" />
  <figcaption>This is not entirely an issue! If you want to ship static websites then... don't use a framework I guess. This was brought up just to showcase my issue. SvelteKit and alternatives offer a way to disable this behavior but that has other disadvantages.</figcaption>
</figure>

You should be able to piece it together now. Svelte would bundle SVG icons with the other bundles, changing the page would invalidate the cache. Splitting the icons into a separate component created the same issue of downloading the whole bundle even if only one icon was needed (and even if some of the icons in the bundle were completely unused). Embedding the icons in the template would cause the same issue as the 'Hello World' example, where they would be shipped both in the HTML and in the bundle. Lastly, icons would depend on JS and if it's disabled they would be missing.

At the time, you could disable hydration(? sorry I can't remember the exact term) but it would remove all JS, including stuff like the theme switcher and button callbacks.

# The Ultimate Solution

Welp, only left to do is scratch my own itch and write an SSG... again. In Crystal of course!

When discussing the approaches, one of them has disadvantages that we can actually overcome, the SVG sprites. The main one being that you need to download the whole sprite for a singe icons. The solution was quite straight-forward:

What if we just created a different SVG Sprite for every single icon? That way the approach is a combination of `<img />` and embedding in HTML without their disadvantages. When you use an icon, you only request that one and it gets cached, individually, just like `<img />` but you can use CSS on them, like embedding in HTML.

The biggest roadblock is making sure the icons have similar sizes and spacing. It requires a bit more time, but with a bit of light editing, all icons are 24x24, filling the canvas. The sprites are created in the SSG automatically when generating the website, based on the icons found in the folder.

Gradients are messy, so full-color icons are using `<img />` instead of sprites.

That's pretty much all on icons. Building a custom SSG allowed me to minimize the amount of data this website transfers while having all the features I need.
