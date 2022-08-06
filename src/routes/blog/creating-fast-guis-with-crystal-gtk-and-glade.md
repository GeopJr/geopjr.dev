---
title: Creating fast GUIs
subtitle: with Crystal, GTK and Glade
date: 2020-12-19
updated: 2022-08-06
tags:
    - crystal
    - gnome
---

# Edit

You should really take a look at the [Ultimate GTK4 Crystal Guide](https://ultimate-gtk4-crystal-guide.geopjr.dev/) instead.

A guide that will teach you how to make GTK4 apps with Crystal covering everything from UI to I18N.

The original post will be kept for archival reasons, you really shouldn't follow it.

# Original

There's this misconception that building GUIs is often hard, tedious and requires a lot of skill. Or at least that's what electron was supposed to fix.

While electron certainly gives developers a head-start, it also hides many problems that they are going to come across. Some of which are: Performance, Vulnerabilities and Build Sizes.

When it comes to native GUIs, as a GNU/Linux and GNOME enthusiast, I decided to go with GTK, a FOSS widget toolkit for GUIs.

Let's get started!

# Glade

Glade is a RAD tool that enables quick and easy development of user interfaces for the GTK toolkit and the GNOME desktop environment.
> from: https://www.gtk.org/

From my time playing around with Glade, I made the following conclusions:

- It's fast
- It's easy
- It's beautiful

![glade screenshot](https://i.imgur.com/5A6sihQ.png)

The middle panel is where you create your UI, by drag-n-dropping widgets from the menu bar. If you are familiar with CSS' flexbox, you can use similar concepts using containers > boxes, allowing you to create responsive designs!

On the right panel, you get to edit properties of the selected widget. You might notice (by looking at the left panel) that I haven't given all widgets an ID, that's because most of them are static and I don't need to know or edit their properties in backend.

> IMPORTANT: Don't forget to bind the `destroy` signal under GtkWidget of your main window to `gtk_main_quit` so that the backend exits when the window closes!

![signal bind screenshot](https://i.imgur.com/DLsFU2b.png)

# Backend

I used Crystal for my backend. There's a shard that provides binding for GObject Introspection.

https://github.com/jhass/crystal-gobject

The repo includes many examples to get you started!

First things first, we need to load and bind our Glade file:

```crystal
builder = Gtk::Builder.new_from_file "#{__DIR__}/my_ui.glade"
builder.connect_signals
```

Now, let's say that we made a Switch in Glade, with the ID of `my_switch` and we want to check if it's ON or OFF:

```crystal
my_switch = Gtk::Switch.cast(builder["my_switch"])

puts "my_switch is #{my_switch.active ? "on" : "off"}"
```

Every widget has it's own events and properties, like `Gtk::Switch#on_state_set` which gets triggered when the state of a certain switch changes!

> TIP: Unsure about what's available? Use macros!
> eg. `{{ Gtk::Switch.methods.map &.name.stringify }}`

Last but not least, it's time to show our window (in my case, with the ID of `main_window`):

```crystal
window = Gtk::Window.cast builder["main_window"]
window.show_all
```

And that's all!

# Usage

I used it to create a GUI for my previous project, Crycord:

https://github.com/GeopJr/Crycord

/injecting-electron-apps-with-crystal

which can be found here:

https://github.com/GeopJr/Crycord-GUI

I'm happy with the way it turned out, here's a screenshot of it displaying the STDOUT of Crycord:

![screenshot of crycord gui](https://i.imgur.com/2lO45U2.png)

Had quite some fun as this is my first experience with GTK and will definitely use it more in the future!
