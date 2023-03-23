class Egg {
    #passed
    #event

    /**
     * @param {string} pattern 
     * @param {{once: boolean, skip_space: boolean, case_sensitive: boolean, one_at_a_time: boolean}} config 
     * @param {*} callback 
     */
    constructor(pattern, config, callback) {
        this.pattern = this.pattern = pattern.split("")
        this.callback = callback
        this.config = {
            once: false,
            skip_space: false,
            case_sensitive: false,
            one_at_a_time: false,
            ...config
        }
        this.#passed = 0;

        if (config.skip_space) this.pattern = this.pattern.filter(x => x !== " ")
        if (!config.case_sensitive) this.pattern = this.pattern.map(x => x.toLowerCase())

        this.registered = false

        this.#event = this.#keypressHandler.bind(this)
    }

    #keypressHandler(event) {
        if (!this.registered) return

        const key = this.config.case_sensitive ? event.key : event.key.toLowerCase()
        if (this.config.skip_space && key === " ") return

        if (this.pattern.indexOf(key) < 0 || event.key !== this.pattern[this.#passed]) {
            this.#passed = 0;
            return;
        }

        this.#passed++;
        if (this.pattern.length === this.#passed) {
            if (this.config.once) {
                document.removeEventListener('keydown', this.#event, false)
            } else {
                this.#passed = 0;
            }

            if (this.config.one_at_a_time) {
                document.onkeydown = null;
            }

            this.callback()
        }
    }

    register() {
        document.addEventListener('keydown', this.#event, false);
        this.registered = true
    }
}

/**
 * @param {string} source 
 * @returns {HTMLAudioElement}
 */
const play_sound = (source) => {
    const audio = document.createElement("audio");
    audio.autoplay = true;
    audio.load()
    audio.addEventListener("load", function () {
        audio.play();
    }, true);
    audio.src = source;

    return audio
}

const main = document.getElementsByTagName("main")[0]

const clear_main = () => {
    [...document.body.children].forEach(x => {
        x.tagName === "MAIN" ? x.innerHTML = "" : x.remove()
    });
}
