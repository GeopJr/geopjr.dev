export class Egg {
    #passed = 0
    #event

    /**
     * @param {string} pattern 
     * @param {{once: boolean, skip_space: boolean, case_sensitive: boolean, one_at_a_time: boolean}} config 
     * @param {*} callback 
     */
    constructor(pattern, config, callback) {
        this.pattern = pattern.split("")
        this.callback = callback
        this.config = {
            once: false,
            skip_space: false,
            case_sensitive: false,
            one_at_a_time: false,
            ...config
        }

        if (config.skip_space) this.pattern = this.pattern.filter(x => x !== " ")
        if (!config.case_sensitive) this.pattern = this.pattern.map(x => x.toLowerCase())

        this.registered = false

        this.#event = this.#keypressHandler.bind(this)
    }

    #keypressHandler(event) {
        const key = this.config.case_sensitive ? event.key : event.key.toLowerCase()
        if (this.config.skip_space && key === " ") return

        if (key !== this.pattern[this.#passed]) {
            this.#passed = 0
            return
        }

        this.#passed++;
        if (this.#passed === this.pattern.length) {
            if (this.config.once)
                document.removeEventListener("keydown", this.#event)

            if (this.config.one_at_a_time)
                document.onkeydown = null

            this.#passed = 0
            this.callback()
        }
    }

    register() {
        document.addEventListener('keydown', this.#event, false);
    }

    static get main() {
        return document.querySelector("main")
    }

    static clearMain() {
        [...document.body.children].forEach(x => {
            x.tagName === "MAIN"
                ? x.innerHTML = ""
                : x.remove()
        })
    }

    /**
    * @param {string} source 
    * @returns {HTMLAudioElement}
    */
    static playSound(source) {
        const audio = document.createElement("audio")
        audio.autoplay = true
        audio.src = source
        return audio
    }
}
