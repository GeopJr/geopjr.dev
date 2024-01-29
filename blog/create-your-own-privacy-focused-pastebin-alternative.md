---
title: Create your own privacy focused pastebin alternative
date: 2021-04-23
tags:
    - vue
    - crystal
    - privacy
    - encryption
hidden: true
---

Ever wanted to share some long text with your friends, or maybe some code that might include a token or two? Usually, you will probably consider using a free text bin like pastebin or hastebin, but neither of them is encrypted. However they offer great and accessible UIs as well as code highlighting.

That's where BeardBin comes in, a Zero-Knowledge Encrypted Text/Code sharing bin. There are two parts to it:
- Backend: written in Crystal, responsible for saving to, deleting and retrieving posts from the database.
- Frontend: written in Vue, responsible for decrypting and encrypting text, communicating with the backend and handling user input.

# Backend
Since backend has a tiny role in the whole project, I focused on speed, that's why I went with Crystal and [Kemal](https://kemalcr.com/), a super fast web framework that can handle huge amounts of requests per second.

Let's create a simple record that will act as a mongodb document.
```crystal
record Bin, _id : String = UUIX.random, content : String? = "",
            code : Bool? = false, creation_date : Time = Time.utc,
            custom_password : Bool? = false, view_once : Bool? = false,
            delete_id : String? = Random::Secure.urlsafe_base64(64, padding: false)[0, 64],
            iv : String? = ""
```

- **_id:** The id of the Bin which is a url-safe UUID made using [UUIX](https://github.com/krthr/uuix).
- **content:** The *encrypted* content of the bin.
- **code:** Whether or not the content should have code-highlighting enabled.
- **creation_date:** The date it was created on (mainly for database cleanup (eg. deleting all posts older than 6 months old)).
- **custom_password:** Whether or not it has a custom password.
- **view_once:** Whether or not it should be deleting after being viewed.
- **delete_id:** A random secure String from [stdlib](https://crystal-lang.org/api/1.0.0/Random/Secure.html) converted to urlsafe base64. This is being used by the author to delete the bin manually.
- **iv:** The iv used in the encryption process.

The rest of the code is handling the post requests to the `/create`, `/retrieve` and `/delete` endpoints, doing the necessary calls to the database and sending responses with correct status codes.

Lastly, the backend also handles `view_once`, which will delete the document just before sending it to the user.

# Frontend
The frontend handles both encryption and decryption of the content. Why? Because you don't have to trust the server (and the network) when they are being done client-side.
## Spec
Having a clear spec on the encryption is important both for users and to keep us on track.
![a flowchart that acts as encryption spec](https://raw.githubusercontent.com/GeopJr/BeardBin/main/specs.svg)
(If it looks weird, check it on [GitHub](https://raw.githubusercontent.com/GeopJr/BeardBin/main/specs.svg))

The decryption key is ***on*** the url itself, allowing anyone with the url to decrypt the content (unless it has a custom password set on top).

## Code
Enough of that, let's go back to coding!
We need to add some plugins to Vue before we start:
- [Vue Router](https://router.vuejs.org/): Used to handle the url params.
- [Vuex](https://vuex.vuejs.org/): Used as a global store and for resetting everything on new-file.
- [Vuetify](https://vuetifyjs.com/): A material design framework for Vue.
- [vue-highlight.js](https://github.com/gluons/vue-highlight.js/): Used for code-highlighting.

I won't go through all the components since they are a lot, but they mostly accept user input which then gets set in Vuex.

### on `mounted`
Our routes look like this:
```js
const routes = [
  { path: '/:id/' },
  { path: '/:id/:key' },
  { path: '/:id/delete' }
]
```
You can access those params like this: `this.$route.params.<param_name>`.
So on mounted, we save both the id and decryption on store, allowing all components to easily access them.
After that, we show the correct modal (if required) based on whether or not the bin has a custom password, there's something missing or the `/delete` endpoint was called.

### Encryption

Encryption (and decryption) are being handled by [CryptoJS](https://cryptojs.gitbook.io/docs/).

Since we are using AES for the base encryption, we need to generate an [IV](https://en.wikipedia.org/wiki/Initialization_vector). The IV doesn't have to be secret as long as it's random for each entry. That's why it's saved as plain text in the database. To generate it, we use CryptoJS' WordArrays.
> A WordArray object represents an array of 32-bit words.

Afterwards we need to create a secure key to encrypt with PBKDF2.
> PBKDF2 is a password-based key derivation function.

In combination with [secure-random-password](https://www.npmjs.com/package/secure-random-password) and a random WordArray as a salt, we generate a PBKDF2 key with the size of 512 / 32 and 1000 iterations.

Then we use both the PBKDF2 key and the IV generated above to encrypt the user content.

Lastly, if there's a custom password set, we encrypt the already encrypted content using RABBIT with it. And of course, we send the required info to the backend and show the user a modal that contains the URL of the Bin plus the deletion key.

### Decryption

Decryption works in a similar manner, but in reverse.

If the content has a custom password, the user gets asked to input it on mounted. So now the content is no longer RABBIT encrypted and we can continue with the AES decryption.

After the content gets AES decrypted using the decryption key from the URL and the IV from the backend, it gets saved in store so the TextArea can access it.

If the Bin was marked as `code`, the content will pass through highlight.js with auto-detector in an attempt to detect and correctly highlight it.

# Conclusion

While there are many parts and layers to this project, I decided to mention only the most critical ones.
Privacy is important, including on things we don't usually think about.

# Screenshots

![Screenshot of the main UI of beardbin](https://camo.githubusercontent.com/70cc8ba816312526352f2787a85fe3853197e184aaf35d20bc726a718a33fc0d/68747470733a2f2f692e696d6775722e636f6d2f6c335569434a312e706e67)
![Screenshot of beardbin with some highlighted code](https://camo.githubusercontent.com/3c395eab1e83a359b24b6807b2d4bc5d718faf02102298a3bf02be64b88a69bd/68747470733a2f2f692e696d6775722e636f6d2f676f6e47726d302e706e67)
![Screenshot of beardbin with a qrcode modal](https://camo.githubusercontent.com/fe070d91976a8d94682605c82e0196ec339c5b36dcecf2c383b508909c9e308d/68747470733a2f2f692e696d6775722e636f6d2f6d7849657a4a6e2e706e67)

# Links

I have an instance of BeardBin running on a heroku VPS, but since the domain might change anytime, you should grab it from the GitHub repo (it's on the sidebar).


https://github.com/GeopJr/BeardBin