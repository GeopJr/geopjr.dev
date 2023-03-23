/**
 * @param {string} text
 * @param {string?} style
 */
const omori_console = (text, style = "") => {
    console.log(`%c${text}`, `font-family:'OMORI_GAME';font-size:3em;${style}`);
}

const omori_play_meow = () => {
    document.getElementById('meow').play()
}

const omori_callback = () => {
    clear_main()
    omori_console("Everything is going to be okay.")

    document.getElementsByTagName("head")[0].insertAdjacentHTML(
        "beforeend",
        "<link rel=\"stylesheet\" href=\"/assets/css/egg/omori.css\" />");

    document.documentElement.dataset.egg = "omori"

    const html = `
        <div class="lamp-container">
            <img src="/assets/images/lightbulb.gif" alt="A pixel-art laptop from the game OMORI. Its screen has animated TV static." />
        </div>
        <div>
            <h1>Congrats on finding this easter egg!</h1>
            <h2>Refresh the page to go back</h2>
        </div>
        <img src="/assets/images/mewo.webp" id="mewo" alt="Mewo from OMORI - A black pixel-art cat sleeping (animates)" onclick="omori_play_meow()" />
        <audio id="meow" src="/assets/audio/mewo.ogg">
    `

    main.append(play_sound("assets/audio/something.mp3"))
    main.insertAdjacentHTML("beforeend", html)
}

const omori_egg = new Egg("welcome to black space", { once: true, skip_space: true, one_at_a_time: true }, omori_callback)
omori_egg.register()
