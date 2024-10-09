---
title: "Unjected 2: Electric Boogaloo"
subtitle: A case study on how little you can care about user data
date: 2024-10-09
tags:
    - security
    - bug
    - crystal
    - javascript
---

Where do I even begin with this one...

In 2022, I [accidentally discovered an insecure admin panel for a dating site for anti-vaxxers and bodily fluid marketplace named Unjected](https://geopjr.dev/blog/how-i-hacked-an-anti-vaxxer-dating-and-bodily-fluid-marketplace-website) giving me access to all user data among other things.

A few months ago, I decided to revisit it, after seeing them make snarky posts on Twitter. They re-wrote the website in React (for the frontend) and Express (for the backend). A solid and cheaper choice than Django would have been, but at the cost of far lower entry level.

> Disclaimer: This blog post will include mostly the technical side of [the original Daily Dot article](https://www.dailydot.com/debug/anti-vax-dating-site-unjected-private-user-data-dms/). No additional information will be provided than what was included in that article. I'll try to avoid being *too* specific as not everything is fixed at the time of writing this.

![Speech bubble on a smiling dog with the text 'Waiter! Waiter! more user data please!!']({{GEOPJR_BLOG_ASSETS}}/waiter.webp)

This time, instead of me having to dig around a bit, the backend served me user e-mails, without me even asking. Thanks, I guess? The API and frontend were designed in a way that to show a user profile, it *would* give you their e-mail and other info like location and birthday too. Which brings me to the first point:

# No, Unjected, I am not a troll

A troll wouldn't report security issues and try to get them fixed. A troll would first change everyone's profile picture, names and other data, then deactivate everyone and finally sell the breach on forums.

A few days after the Daily Dot published my findings, the Unjected Team went on a podcast and talked about it briefly. In their attempts to avoid taking responsibility for their negligence for a second time, they made some assumptions about me along with a combination of threats and compliments (?).

No Unjected, I do not do this for a living. It doesn't require a PhD for someone to use their web browser's inspector and see that that the API returns private user data. And no, I am not anonymous. My full name and country is available in many places, including this website. I don't have to constantly show my face or overshare because that's not my goal. I am not trying to be an influencer, podcast host, youtuber or instragram model. I work with computers, that's all.

<figure>
  <img src="{{GEOPJR_EMOTES_?}}" alt="" class="emote pixelated" />
  <figcaption>Maybe your users should ask you why you are on podcasts instead of securing your website?</figcaption>
</figure>

You also claimed that you've done pentesting before. I hope you can still ask for a refund, because as we dive more into it, you'll notice that even a regular person would be able to find user e-mails by simply pressing Ctrl+Shift+I.

Lastly, I find it ironic that you said and I quote "Our legal team is currently investigating the situation and are ready to take action, so we are certain that the situation ends here". Are you threatening me with legal action because I... found security issues with your website, let you know about it *and* told you how to fix them?

<figure>
  <img src="{{GEOPJR_EMOTES_DEFAULT_HOODIE_Ω}}" alt="" class="emote pixelated" />
  <figcaption>As a sidenote, my avatar features <a href="https://starbound.fandom.com/wiki/Rainbow_Cape" rel="noopener noreferrer" target="_blank">a rare item in the game Starbound called Rainbow Cape</a>. I'm sure it was worth pointing out to your listeners, 👻 BOO 🌈</figcaption>
</figure>

Want to make sure that the situation ends here? Start treating user data as **private info**. If I can be sued for monitoring my network requests, then all browsers should be illegal. On the other hand, later in this article, we'll talk about potential GDPR violations (that I also notified you about).

# API Design 101

Never return anything private without authentication. Simple, right? A good rule of thumb is that unless you display it, it shouldn't be there.

Imagine my surprise when I open my browser's web inspector and the first request I see, includes my e-mail.

Here's an example:
```json
{"status":"success","data":{"code":"PROFILE FOUND","message":"Profile successfully retrieved","data":{"id":0,"is_admin_user":null,"time_created":"","time_updated":"","time_removed":null,"cognito_user_id":"","first_name":"","last_name":"","email":"","birthday":"","hidden_birthday":false,"gender":0,"address":null,"about_me":"","username":"","looking_for_id":null,"looking_for":null,"profession_id":null,"profession":null,"marital_status_id":null,"marital_status":null,"children":null,"starsign_id":null,"starsign":null,"instagram":null,"twitter":null,"website":null,"deactivated":false,"legacy_user_id":0,"longitude":0,"latitude":0,"label":"","country":"","region":"","sub_region":"","municipality":"","street":"","permission_names":null,"image_path":null,"interests":[],"languages":[],"images":[]}}}
```

The important ones are: `email`, `hidden_birthday`, `longitude`, `latitude`, `deactivated`, `municipality`, `street` and `images`.

Getting that info requires 0 authentication and the frontend requests it whenever it has to load a profile, anyone's profile, by doing a GET request at `/<user id>`. This information wasn't gathered using any sophisticated hacking tool or similar, any browser's inspector 'Network' tab will show you any requests a website does.

<img src="{{GEOPJR_EMOTES_X}}" alt="" class="emote pixelated" />

Why was this done? I assume partially to avoid another request when editing your own profile and perhaps the developers behind this not realizing that it's available for the whole world to see.

Okay, you might be wondering now why the other entries are important. When `hidden_birthday` is true, it won't show your birthday on your profile, but the API still includes it. **108** users had set their birthday to hidden. Similarly for `deactivated`, deactivated accounts are not accessible on the website *but* the API will still return them in full (GDPR who?). **1989** users had deactivated their accounts.

<figure>
  <img src="{{GEOPJR_EMOTES_!}}" alt="" class="emote pixelated" />
  <figcaption>Deleting your account is never enough, you shouldn't have made it in the first place.</figcaption>
</figure>

`longitude`, `latitude`, `municipality` and `street` are just very specific and useless information. When you set your `location`, it uses a map service and for some reason they decided to save everything it returned in the user objects, allowing anyone to see anyone's **exact** location.

Last but not least, `images` is one I cannot even explain. It's an array of objects that had a boolean key letting you know if an image had been deleted. The 'deleted' images are still available in their CDN. I repeat, deleted images are NOT removed. To be fair, they do get removed from the `images` array but the URLs are still very much alive.

<figure>
  <img src="{{GEOPJR_EMOTES_?}}" alt="" class="emote pixelated" />
  <figcaption>Why? Just delete them?!?!</figcaption>
</figure>

# A door that accepts any key

When writing an API that requires authentication, you check that the token provided is the right one. While I don't think anyone needs this lesson, a way to force yourself to never make this mistake is to get the current user *from* the token, instead of another field. For example, instead of `/change_password?token=XXXXXX&user=geopjr` you should do `/change_password?token=XXXXXX` and get the user the token belongs to from your database.

In my 2022 report, I noted that I could block anyone as anyone, since endpoints not only accepted *who* did an action but required it. This is the exact same situation.

<figure>
  <img src="{{GEOPJR_EMOTES_?}}" alt="" class="emote pixelated" />
  <figcaption>Seriously, how many times will you repeat this mistake?</figcaption>
</figure>

I was walking home (👻 wearing a mask 👻) and thought to myself, "there's no way they are not checking if the token belongs to the account it modifies, right?". Guess what? I could change anyone's profile, get their DMs and later even deactivate them, using my token!

What's even more bizarre is that some endpoints **didn't even require authentication**, you could change anyone's profile picture and get whether two users had messaged each other before, without providing *ANYTHING*.

Gathering this data required some scripting. Iterating over every single user, I would first do a request to see if they had participated in any conversations and then would iterate through all of them, one by one, formatting them into an easily readable format (you saw a snippet of that in the Daily Dot article). Writing that took seconds with Crystal's standard library, in less than 50 lines!

# Aftermath?

I contacted the only person I trust when this happens, [Mikael Thalen](https://twitter.com/mikaelthalen). After exchanging messages, it was time to report it to the Unjected team. I wrote a brief write up, not only documenting the security holes but also providing solutions.

The solutions were easy to follow and very straightforward like "Don't return e-mails unless a token that matches the requested user was provided". Nobody should have trouble following that. Nobody except the people working at Unjected.

<figure>
  <img src="{{GEOPJR_EMOTES_OK}}" alt="" class="emote pixelated" />
  <figcaption>Essential oils do not in-fact work on technology.</figcaption>
</figure>

They instead decided to... **encrypt all API responses** with a **static AES key**. So now every time you click on a profile, you get an encrypted string that your browser decrypts with a static password / same for everyone. What this did was just create a small inconvenience for anyone scrapping this while increasing the amount of JS shipped (since it now includes a whole crypto library just to decrypt them) and increasing the amount of processing every single user has to do, especially noticeable on low end devices, by requiring them to decrypt every single API response.

> If you want the actual numbers, since they bundle everything into a huge single file, every time they modify their frontend (and cache gets invalidated), every single user downloads and runs at least **16.30 MB** (~3 gzipped) of JS. In comparison, Amazon, a far more complex website, transfers 1.43 MB (~0.3 gzipped) of JS and in many small cache-able bundles.

Here's how 'difficult' (/s) it was to decrypt it:

```js
import aes from 'crypto-js/aes.js'
import utf8 from 'crypto-js/enc-utf8.js'

const decryptData = (encryptedData, secretKey) => {
    const bytes = aes.decrypt(encryptedData, secretKey)
    const decryptedData = bytes.toString(utf8)
    return JSON.parse(decryptedData)
}

console.log(decryptData("SUPER ENCRYPTED API RESPONSE", "SUPER SECRET DECRYPTION KEY"))
```

And just like that, e-mails are still there. A bandage over the problem.

<figure>
  <img src="{{GEOPJR_EMOTES_?}}" alt="" class="emote pixelated" />
  <figcaption>I really cannot understand why they chose client-side decryption over just not sending everyone's e-mails with their profile.</figcaption>
</figure>

They spent more time going to podcasts and arguing with twitter users than fixing the problem. None of the problems have been fixed at the time of writing this. None of the problems were fixed when the Daily Dot article was published, even though they were notified in advance. Instead they sent a snarky response back, "MIKAELISLONELY". Wish they would have spent this time protecting their users.

It's weird that I care more about their users' data than they do. Both now and in 2022, I did everything in my power to delay the article until everything was fixed. Both then and now, I deleted everything gathered from my machine. Both then and now, I sent them a write-up with solutions. And once again, I won't publish this blog post until everything (or at least most) is fixed.

Trust me, you haven't experienced how bad things can go if medical data falls into the hands of malicious actors. Next time it might not be me the one who discovers security vulnerabilities on your website and whoever does will not be as kind. A little bad publicity would be the least of your problems.

Get vaccinated.<br/>
Stream A.G. Cook.<br/>
🏳️‍🌈🏳️‍⚧️ Happy Pride Month Unjected!

<br/>

> P.S. This post did not focus just on technical side of things even though that was the original intention. After the (extremely boring) podcast episode was brought to my attention, I just had to respond to some of the claims made there. The 'do your own research' crowd failed miserably to do that, as expected. It even started with the claim that I call myself 'Dr. Fauci' due to the joke subtitle in the 2022 post. The third person also brought up that if the website is trademarked, screenshots of its API responses should also be 🤪, maybe some ideas for the next [Google v. Oracle](https://en.wikipedia.org/wiki/Google_LLC_v._Oracle_America,_Inc.)...

<br/>

**Update 2024-04-16**: Still not fixed. They made the decryption key an env variable, which doesn't make it secret. Any code that runs client-side, can't contain secrets. API endpoints that didn't require *any* token, do now but... they once again, do not check if the token matches the requested account, so you can get any info using your own.

**Update 2024-05-08**: I gathered the ~**1500** accounts added *after* the DailyDot article came out. Issues still exist, e-mails are still included.

**Update 2024-06-13**: I gathered ~**2300** more accounts.

**Update 2024-10-09**: Four months later. They now got rid of the web app and have a flutter app for Android and iOS.

While it's not possible to use the web app anymore, the API is still accessible. But only if you know how to get a new token.

Luckily, I have documented their API better than they did, so it's time to get the last batch of users from it, decrypt them and publish this article, half a year after I wrote it.

As of today, another **7394** users and all their private messages have been leaked from Unjected. Congrats Frederick for being the last one!

Goodbye for now! Oh and educators, you know you don't have to use your .edu e-mail outside of work, right?
