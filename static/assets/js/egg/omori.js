import { Egg } from "../egg.js"

/**
 * @param {string} text
 * @param {string?} style
 */
const omoriConsole = (text, style = "") => {
    console.log(
        `%c${text}`,
        `font-family:'OMORI_GAME';font-size:3em;${style}`
    )
}

const omoriCallback = () => {
    Egg.clearMain()

    omoriConsole("Everything is going to be okay.")

    document.head.insertAdjacentHTML(
        "beforeend",
        `<link rel="stylesheet" href="/assets/css/egg/omori.css">`
    )

    document.documentElement.dataset.egg = "omori"

    const html = `
        <div class="lamp-container">
            <img src="/assets/images/lightbulb.gif" alt="A pixel-art laptop from the game OMORI. Its screen has animated TV static." />
        </div>
        <div>
            <h1>Congrats on finding this easter egg!</h1>
            <h2>Refresh the page to go back</h2>
        </div>
        <img src="/assets/images/mewo.webp" id="mewo" alt="Mewo from OMORI - A black pixel-art cat sleeping (animates)" />
        <audio id="meow" src="/assets/audio/mewo.ogg">
    `

    Egg.main.append(
        Egg.playSound("/assets/audio/something.mp3")
    )

    Egg.main.insertAdjacentHTML("beforeend", html)

    document
        .getElementById("mewo")
        ?.addEventListener("click", () =>
            document.getElementById("meow")?.play()
        )
}

new Egg(
    "welcome to black space",
    { once: true, skip_space: true, one_at_a_time: true },
    omoriCallback
).register()
