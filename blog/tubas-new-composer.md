---
title: Tuba's New Composer
subtitle: Why did it take so long?
date: 2025-08-11
tags:
    - linux
    - gtk
    - vala
---

This week, after ~8 months, I made another Tuba release. v0.10.0 is now available! Tuba releases are huuuuuuuuuuuuuge and this one is not different. The main reason for that is that the Fediverse as a whole is moving *fast* and there are a handful of new features available between every release cycle.

However, this release's spotlight is on an old feature, an essential part of every microblogging platform, the composer.

# It can't be thaaaaaaaaaat long, right?

It is, at least for Tuba & me. Schedule-wise, I always aimed bi-monthly releases - enough time to add as many features as I can without burning out but not long enough for people to think it's abandoned.

Feature-wise, usually, if something interests me or someone else spent time on something, I want to respond quickly. I'll implement design mockups and add features the same day they come to my attention. You can easily find examples of these on the repo.

I'm pointing this out to show how unusual an 8-month long development period is (and to be frank the changelog does not reflect that at first sight).

Tobias dropped the design mockups for the new composer on September 25, 2023 and they were working on them for a while already. I finished the new composer layout and made a PR on October 28, 2023. But, the new composer was ready and merged on July 8, 2025, almost 2 years later!

# So, why did it take that long?

Platforms have Human Interface Guidelines (HIG) that's basically 'design documentation' for developers and designers targeting them. [GNOME](https://developer.gnome.org/hig/), [KDE](https://develop.kde.org/hig/), [Microsoft](https://fluent2.microsoft.design/), [Apple](https://developer.apple.com/design/human-interface-guidelines/), [Google](https://m3.material.io/), and even social platforms have their own HIGs.

HIGs can't cover everything, they only cover common patterns, pitfalls, and general guidelines, leaving you to your own devices when it comes to unique patterns that nobody has done before.

An example would be Tuba's pull to refresh. In the beginning it was similar to iOS' way of dragging the content down and lifting after a threshold to refresh, but due to some technical reasons down the line with another component, it changed to the Android-like way of revealing an overlay spinner at the top and lifting after a threshold to refresh.

But that's a very basic example, what happens if the platform doesn't support what you want to do out of the box?

# Technical roadblocks

## `ScrolledWindow` and `Scrollable`

Let's talk about GTK's `ScrolledWindow`. It's a container that makes its child scrollable. That mean a lot of things but for this case, it means that the child's size won't affect the window size, if it exceeds a certain limit, scrollbars will appear.

A common pitfall with the `ScrolledWindow` is that users think of it as a typical container, like so: `ScrolledWindow -> Widget`. But that's not true, `ScrolledWindow` expects the child to implement the `Scrollable` interface which, in layman's terms, defines how scrolling works.

When you set the child to something that doesn't implement it, `ScrolledWindow` will wrap it inside a `Viewport` which is a basic container that implements `Scrollable`. Therefore, it becomes `ScrolledWindow -> Viewport -> Widget`. So where's the problem?

Well, some (usually complex) widgets implement `Scrollable` themselves either for optimization reasons (by freeing what's not visible) or because they actually need more control over the scrolling process. Two of them are the recycler views (`ListView`, `GridView`) and `TextView`. In that case, the structure becomes `ScrolledWindow -> (Scrollable) Widget`. But UX is not always this straightforward. How would you add a `Button` at the top of a `ListView` that scrolls with it?

This is where the problems start. What users commonly do is create a `Box`, append the `Button` and the `ListView` and shove it in a `ScrolledWindow`. With the above knowledge however, we know that the structure will actually become `ScrolledWindow -> Viewport -> Box -> Button | ListView`. `ListView`, which is `Scrollable` expects to have control over the scrolling process but it doesn't, only the direct child of the `ScrolledWindow` does, and in this case, it's the `Viewport`.

Your app is broken. The `ListView` is a recycler view, as the name implies, it recycles widgets as you scroll. In the above structure, it will appear 'cropped' at the edges and scrolling will either not work or be *very* buggy. The only correct structure is `ScrolledWindow -> ListView` (or just `ScrolledWindow -> ClampScrollable -> ListView` but that's a special widget just for this).

## The New Composer Problem

A big part of the new composer is that the title, nested post and the sub-components (Polls and Attachments) are *inside* the `TextView`. They scroll as you scroll and their size does not influence the window size. Before I get more into it, let's talk about `TextView`'s `Scrollable` implementation for a second.

I cannot tell you exactly *what* it does with it (from word of mouth, it at least optimizes for huge walls of text) but I can tell you what's broken when it's inside a `Viewport`... Not much!

It will be usable, many apps ship it like that already but a quick way to tell without the inspector is that the scroll position won't follow the cursor. If you move with the arrows below what's visible or add newlines, the scroll position will just stay in the initial position. That's not great. At least not for a composer.

How do we approach this? Honestly, no idea. I tried everything I could think of. I tried replicating `ClampScrollable` but with a more `Box`-like layout, I tried weird overlays that hide as you scroll, I tried revealers, I tried not using a ScrolledWindow at all and much much much much more.

Getting over this issue would determine whether the new composer would actually happen at all since it about its base. I couldn't work on the other things until that was done because their implementation would depend on how it was implemented itself.

## Research

During my tiny break after LAS, I remembered that when I was trying to figure out custom emojis in text (which can be a huge blog post on its own), I explored `TextView`'s 'anchored widgets'.

`TextView`s can have nested widgets in them between the text. Any widget. The caveat however is that they act as part of the text, you can delete them with Backspace and are not really suitable for something as advances as the polls and attachments part of the composer. I knew that already though. What I was interested in was *how* they were implemented.

But I didn't do it, because something else caught my attention even more, the `add_overlay` function. According to the docs:

> Adds child at a fixed coordinate in the `GtkTextView`'s text window.

That means that it will stay in the text position as you scroll, almost exactly what we are looking for.

I've gotten quite familiar with the inner workings of GTK after all the time spent on trying to hack around all the LabelWithWidgets issues so I knew what to look for. The TLDR is that during `size_allocate`, a `y_offset` value is used to determine the y position of the allocation based on the scroll position (and margins and other conditions). What I need is the `y_offset`, surely I can get it somehow, right?

Nope. It's a private variable. Would you look at the time; GTK 4.18 is available now, let's see what's new!

> `TextView#get_visible_offset`: Gets the X,Y offset in buffer coordinates of the top-left corner of the `TextView`'s text contents.

... That's exactly what I needed.

## Enter `SandwichSourceView`

Let's subclass it and override its `size_allocate` to include our custom widgets in a 'Sandwich' layout based on the y_offset! The basic idea is to measure the widget we are going to put at the top and bottom, allocate them to the right positions and set the `TextView`'s top and bottom margin (note, this is not `margin_top` and `margin_bottom`, these are for the text inside the `TextView`), so it ends up looking like a typical box with top and bottom widgets.

### Challenge #1

Vala hadn't made a release with the GTK 4.18 VAPI yet, so we have to bind it ourselves, easy peasy:

```vala
[CCode (cheader_filename = "gtk/gtk.h", cname = "gtk_text_view_get_visible_offset")]
extern void get_visible_offset (out double x_offset, out double y_offset);
```

behind a flag for Vala < 0.56.19 preferably.

### Challenge #2

The first step is outlining what we need to do:

- measure children
- set top/bottom margins based on the measuring
- allocate children based on the y_offset

But to do it right, you need to fully understand what's the y_offset and what happens when settings the top/bottom margins (spoiler alert: I didn't do it right and spent hours debugging this).

The y_offset is how far the viewport is away from the top-most position of the text. When you are at the top, it's `0`, when you scroll down it will turn into a positive value.

The problems begin when the top margin comes into play. If there's a top margin and you are at the top of the `ScrolledWindow` then the y_offset will be a negative number, because the viewport is actually **above** the top-most text position and will become `0` when the top-margin is no longer visible.

You probably figured it out by now, but the order of things matters. If you get the y-offset first and set the top-margin later, then the y-offset has changed and the allocation of the widgets will be wrong. It has to be done in this order: Measure => Set top/bottom margin => get y_offset => allocate.

The child allocations are mostly about the y axis. The top child needs to be allocated at -1 * y_offset minus its height, so it starts at the top-most position of the `TextView` and gets hidden as the y_offset increases (aka as the view gets scrolled).

The bottom child's y axis gets calculated in a similar way but it has to take into account the top_margin and the whole `TextView` height. It becomes `TextView` height - y_offset - the child height - the top_margin.

### Challenge #3

The child widgets are *inside* the `TextView` which means they are bound by its controllers. Keypress? The `TextView` gets focus. DnD? The `TextView` handles it. Clicks? You get the point.

To fix that we need to add controllers that don't propagate the events further.

### Challenge #N

There were many more challenges, obviously, with scrolling, DnD, animations, sizing but it would take a book to document them all so let's leave it at that.

# Human roadblocks

I lied, that wasn't the only reason it took so long. Unfortunately, I'm still a human. And I'm very tired. I'm too tired to add images to this blog, I'm too tired to post it.
