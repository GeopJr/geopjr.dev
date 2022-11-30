---
title: How I hacked an anti-vaxxer dating (and bodily fluid marketplace) website
subtitle: Sponsored by Dr. Anthony Fauci
date: 2022-11-30
tags:
    - security
    - bug
    - crystal
    - javascript
---

No, Fauci didn't sponsor me but [YOU can](/donate).

Unfortunately, the title of this post is not a joke. There is actually a dating website with a "pure" bodily fluid marketplace called "Unjected". Well... to be honest both the dating and the marketplace parts are more of an afterthought than the main goal.

Unjected is mainly a micro-blogging platform / Twitter alternative for anti-vaxxers, or at least an attempt at it. There were (and still are) numerous problems with it that I won't disclose here - as the more people they push away, the better - except one that annoyed me way more than it should have: it would do a **blocking** request every X seconds to its "notifications" endpoint which would take at least 10 seconds to finish - sometimes it would take so long that by the time it finished, it was time for the next one.

The website is currently under maintenance (foreshadowing) which means it's the perfect time to write this post:

> "We are experiencing a little problem after our last server migration. We have now detected the issue and we are working on it. We will be back very soon. - Team Unjected"

## DISCLAIMER

I'll try not to provide further info than what was published on the [original article at DailyDot](https://www.dailydot.com/debug/anti-vax-dating-site-unjected-data-leak/) outside of some technical aspects. Additionally, I won't provide the endpoints used - Unjected took over 4 days to change a single variable from `True` to `False` (on which I provided a step-by-step guide), I doubt they patched all the endpoints I used (even though I did mention every single one to them).

# Why & How?

Why did I even visit Unjected? Honestly, who wouldn't click a post with a title such as "Unjected now offers mRNA-FREE semen"?

🥱 All I got was an unfinished generic landing page:

![Screenshot of a section of the landing page of unjected. 'Remember craigslist? So do we <emoji of person smiling while blushing>' in big bold text, 'Create listings for whatever subject you want. Find restaurants, housing, services and even things for sale!.' in normal sized non-bold text. Underneath it there's a row of cards. All cards are the exact same one. The card shows a masc person with a beard and glasses. At the top right there's a badge with the text '31 km' on the right of a 'pin' icon. Below the person there's the text 'Célestin,' in black colored bold text and below it the text 'Los Angeles, USA' in grey colored normal text.](https://i.imgur.com/0EwoQRb.png)

Welp, that's all folks, time to close this tab. Oops, almost forgot to check out robots.txt for anything interesting. Uh oh...

## Sin #1

Instead of the expected and beloved `User-agent: *` I got... a Django debug page?

> [Django is a high-level Python web framework](https://www.djangoproject.com/)

A Django debug page provides a lot of info about the environment and the project configuration. On wrong route, it will list all available routes, on error it will show a traceback including some of the code around the listed lines. Additionally, on error it will also show an *extensive* list of environmental variables and configuration options - from database logins and aws server names to whether the process manager is running in "fork_mode".

I want to be clear that this is absolutely not an issue with Django. Django does an excellent job at warning the user about it:

- All tutorials mention that `DEBUG` should be set to `False` in production.
- All debug pages have the following text on their footer: "You’re seeing this error because you have DEBUG = True in your Django settings file. Change that to False, and Django will display a standard 404 page.".
- In `settings.py` there's a security warning above the `DEBUG` variable:

```python
# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True
```

With that out of the way, this is what I was greeted with:

![A basic django default debug page on 404 with the following content: ' Page not found (404) Request Method: 	GET Request URL: 	http://127.0.0.1:8000/robots.txt Using the URLconf defined in mysite.urls, Django tried these URL patterns, in this order:     admin/ The current path, robots.txt, didn’t match any of these. You’re seeing this error because you have DEBUG = True in your Django settings file. Change that to False, and Django will display a standard 404 page.'](https://i.imgur.com/fe6QEE6.png)

> Imagine a list of many routes (read the DISCLAIMER) 

When you visit a route and again provide a sub-route that 404s, Django will return another debug page with this route's available sub-routes. e.g. If I visited `/admin/robots.txt` it would return a list containing `/admin/posts, /admin/delete`.

## Sin #2

At this point, all I had was just a list of all available routes. Not much I can do, they are checking if the person accessing them is an admin... right? RIGHT?

Nope. You didn't even need an account at all for most of them.

The admin endpoint (or whatever it was called), led to the admin dashboard where you (or rather the admins) could modify and/or delete everything:

- Posts
- Reports
- Profiles
- Listings
- Backups
- Static pages (FaQ, About us...)
- Everything.

![Screenshot of the dashboard. There's a sidebar on the left with the following items: Dashboard, Users, Contact Us, Transactions, Management, Manage, Help Center, Feeds, Listing, Blood Bank, Fertility. The Feeds item is selected which has two sub items: Posts (selected), Reported Post. Each sidebar item has a related icon on its left. At the top of the sidebar theres the unjected logo and on its left the word 'Unjected'. On the main panel theres a table with the title of 'Posts' and header items: ID, CONTENTS, CREATED ON, ACTIONS. All the table bodies are censored except for one with the content of 'Server seems slow here. Each row of the action column has 2 buttons: a green one with an eye icon and a red one with a trash car icon.'](https://i.imgur.com/oxhCmYz.png)

## Sin #3

Some endpoints were insecure by design. E.g. you could make anyone block anyone as not only was there not an "actor" check but also the endpoint *required* you to provide who blocked who, like `/block?from={actor_id}&to={targer_id}`. Similarly, you could edit anyone's post.

# Scrapping

> I don't have the exact commands and code I used so I did my best at quickly re-creating them.

First of all, there were two types of pages:

- pages with tables (like the one in the screenshot above)
- pages with formatted text (mostly in a `key: value` format)

Both types of pages followed a similar pagination format: either `/{page_num}` or `?page={page_num}`

Since some of the pages were actually checking for an account (but not an admin account, just an account in general), I had to use the cookies with the Ol' Reliable cURL (in fish):

![Spongebob Squarepants meme. Spongebob holds a case which has a label on one side with the text 'OL' RELIABLE'. On the panel below it, the case is open revealing the cURL logo inside of it. There are sparkles and shiny rays around it.](https://i.imgur.com/SYAjJw6.png)

```sh
for i in (seq $last_page_num); curl --imagine-flags https://unjected.com/.../$i; end
```

## Parsing time

I decided to go with JavaScript for parsing the tables and converting them to csv:

```js
const { Tabletojson: tabletojson } = require('tabletojson');
const { Parser } = require('json2csv');

const fs = require('fs');
const path = require('path');

let jsons = [];

const files = fs.readdirSync("./").filter(x => x.startsWith("index"));

for (let i = 0; i < files.length; i++) {
     const html = fs.readFileSync(path.resolve("./index.html?page=" + i), { encoding: 'UTF-8' });
     jsons = jsons.concat(tabletojson.convert(html)[0]);
}

jsons = jsons.reverse()
const opts = { ['ID', 'Title', 'Created On', 'Actions'] };

try {
    const parser = new Parser(opts);
    const csv = parser.parse(jsons);
    fs.writeFileSync("data.csv", csv);
} catch (err) {
    console.error(err);
}
```

Pretty straight-forward, it reads all pages, converts the tables to json (using [tabletojson](https://www.npmjs.com/package/tabletojson)) and then to csv (using [json2csv](https://www.npmjs.com/package/json2csv)).

On the other hand, to parse non-table pages I used Crystal. Unfortunately I don't have an example to show however I do remember writing an ECR template to compile all posts into a single (giant) html file.

(I didn't need the dashboard to do that. Apparently the endpoint that loaded more posts on the timeline, accepted a limitless range and returned html. I parsed that with Crystal, removed useless items like icons, added CSS and kind-of cleaned the dom).

# Reporting

This is not the first time I stumble upon a security vulnerability. It usually ends with me e-mailing them about it (including everything I gathered), sometimes receive a "thank you" and lastly reassuring them that I've confirmed it got fixed and that I deleted everything from my machine.

Most often than not, I personally use these services or I checked them out because I found them interesting. That's not the case for Unjected. Unjected's goal is to provide a space and echo chamber for conspiracy theories, alternative medicine and alt-right ideologies.

I had no plan on helping Unjected fix their security issues. At the same time I felt the need to help these people that have fallen for conspiracy theories and developed a lack of trust in medical professionals.

So I decided to contact a journalist from the DailyDot that had experience in data leaks, [Mikael Thalen](https://www.dailydot.com/author/mikael-thalen/). 

At first I was scared. This was the first time I contacted a journalist about a data leak and didn't know what to expect, so I decided to do this anonymously. Thankfully, Thalen made me feel more than welcome and safe to talk about the leak!

After some back-and-forth, verifying information and contacting the owners of Unjected, we got a reply back. One of them wanted to talk to me.

I didn't feel comfortable doing so, mostly as 1:1 would mean they could threaten me in an attempt to force me to back out of the article so instead Thalen became the middle-person(?)/messenger between us. If I remember correctly they mostly asked about the issues (I did give them a solution for each one as well).

We are not done yet however. To publish the article, the website had to be fixed (ok maybe not "had to" but I did ask to wait so no user data was vulnerable).

Unjected went down for 1-2 days. Nope. Still not fixed. Many of the issues I told them about - one of which could be solved by just setting `DEBUG` to `False`.

Then the website went down again on Friday. There was now a choice that had to be made, either publish the article on Friday *but* with the chance that Unjected would still not have fixed the issues next time it went up **OR** wait until Monday and see. Ultimately, this wasn't up to me to decide but I did give my opinion of waiting until we could confirm that it got fixed instead of putting user data at risk.

In the end, Unjected went up during the weekend with all the issues (or at least most) fixed and the article got published on Monday.

# Aftermath

After the article went public, a ton of people started joining Unjected (well... mostly trolls). For comparison, when I made the report the last user ID (which is incremental by 1 starting from 0) was around 3.5k which matched the amount of profiles from the dashboard. After the article went public, the last user ID almost doubled.

The timeline was filled with alt-right propaganda, disturbing images, dogwhistles, racism, queer-phobia, ableism and anti-semitism.

I hope at least one person there decided to run away from this conspiracy after realizing that it's actually a pipeline to nazism.

The article (well not the original / the DailyDot one) ended up on The Tonight Show Starring Jimmy Fallon:

https://www.youtube.com/watch?t=320&v=NcMMBAiNjz8

plus I got a new bio:

![Tweet from user SIGINT / @CL0WNWARS. Content: *and shitbag leftist hackers targeted it and mikael is here to write about it for us (ideas for sub headline) 6:10 PM · Jul 25, 2022](https://i.imgur.com/IakWJ2z.png)
