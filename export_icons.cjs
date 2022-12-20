const iconify_tools = require("@iconify/tools")
const fs = require("node:fs")
const path = require("node:path")

const twemoji = require("@iconify-json/twemoji")
const fa_solid = require("@iconify-json/fa-solid")
const fa_brands = require("@iconify-json/fa-brands")
const mdi = require("@iconify-json/mdi")
const simple_icons = require("@iconify-json/simple-icons")

const custom_icon_dir = "./src/lib/icons/"
const out_dir = "./static/icons/"
fs.rmSync(out_dir, { recursive: true, force: true })

const icon = (s, n) => s.icons.icons[s.icons.aliases[n]?.parent ?? n]
const custom_icon = (f) => { return { body: fs.readFileSync(f) } }

const capitalize = (s) => s.charAt(0).toUpperCase()+ s.slice(1)
const get_custom_icons_set = () => {
    const res = {}

    fs.readdirSync(custom_icon_dir).forEach(x => {
        res["c" + capitalize(path.basename(x, ".svg"))] = custom_icon(`${custom_icon_dir}${x}`)
    })

    return res
}

const preset = {
    // Index + Sidebar
    twWave: icon(twemoji, "waving-hand"),
    faBriefcase: icon(fa_solid, "briefcase"),
    faBook: icon(fa_solid, "book"),
    faDonate: icon(fa_solid, "donate"),
    faAddressCard: icon(fa_solid, "address-card"),
    faSun: icon(fa_solid, "sun"),
    faMoon: icon(fa_solid, "moon"),
    faAdjust: icon(fa_solid, "adjust"),
    faCircle: icon(fa_solid, "circle"),
    faBars: icon(fa_solid, "bars"),
    faUser: icon(fa_solid, "user"),
    mdiPentagram: icon(mdi, "pentagram"),

    // Modal
    faTimes: icon(fa_solid, "times"),
    faCopy: icon(fa_solid, "copy"),

    // About + Work
    siNativeScript: icon(simple_icons, "nativescript"),
    siCapacitor: icon(simple_icons, "capacitor"),
    siElixir: icon(simple_icons, "elixir"),
    siRuby: icon(simple_icons, "ruby"),
    siPhp: icon(simple_icons, "php"),
    siQuasar: icon(simple_icons, "quasar"),
    siFlutter: icon(simple_icons, "flutter"),
    siDart: icon(simple_icons, "dart"),
    siCrystal: icon(simple_icons, "crystal"),
    siVue: icon(simple_icons, "vuejs"),
    siSvelte: icon(simple_icons, "svelte"),
    siElectron: icon(simple_icons, "electron"),
    siJs: icon(simple_icons, "javascript"),
    siScss: icon(simple_icons, "sass"),
    siLess: icon(simple_icons, "less"),
    siNode: icon(simple_icons, "nodejs"),
    mdiGNOME: icon(mdi, "gnome"),
    siQt: icon(simple_icons, "qt"),
    siNuxt: icon(simple_icons, "nuxt-dot-js"),
    siVuetify: icon(simple_icons, "vuetify"),
    siExpress: icon(simple_icons, "express"),
    siMaterialDesign: icon(simple_icons, "materialdesign"),
    faPhoenix: icon(fa_brands, "phoenix-framework"),
    faA11y: icon(fa_solid, "universal-access"),
    faSeedling: icon(fa_solid, "seedling"),
    faDocker: icon(fa_brands, "docker"),

    siVite: icon(simple_icons, "vite"),
    faGithubAlt: icon(fa_brands, "github-alt"),
    faNpm: icon(fa_brands, "npm"),
    faChrome: icon(fa_brands, "chrome"),
    faFirefoxBrowser: icon(fa_brands, "firefox-browser"),
    siFlathub: icon(simple_icons, "flathub"),
    faExternalLinkAlt: icon(fa_solid, "external-link-alt"),

    // Blog
    faEye: icon(fa_solid, "eye"),
    faLock: icon(fa_solid, "lock"),
    siAndroid: icon(simple_icons, "android"),
    siLinux: icon(simple_icons, "linux"),
    siCSS: icon(simple_icons, "css3"),
    siWASM: icon(simple_icons, "webassembly"),
    siTS: icon(simple_icons, "typescript"),
    mdiIncognito: icon(mdi, "incognito"),
    faAward: icon(fa_solid, "award"),
    faComment: icon(fa_solid, "comment"),
    faBug: icon(fa_solid, "bug"),
    faShieldAlt: icon(fa_solid, "shield-alt"),

    // Contact
    faEmail: icon(fa_solid, "at"),
    faGitlab: icon(fa_brands, "gitlab"),
    faMastodon: icon(fa_brands, "mastodon"),
    faSteam: icon(fa_brands, "steam"),
    faTelegram: icon(fa_brands, "telegram"),
    siMatrix: icon(simple_icons, "matrix"),
    siCodeberg: icon(simple_icons, "codeberg"),

    // Donate
    siPaypal: icon(simple_icons, "paypal"),
    faGithub: icon(fa_brands, "github"),
    siFlattr: icon(simple_icons, "flattr"),
    siKofi: icon(simple_icons, "kofi"),

    // Custom Icons
    ...get_custom_icons_set()
}

// Import icons
const iconSet = new iconify_tools.IconSet({
    prefix: 'geopjr',
    icons: preset,
    width: 24,
    height: 24,
});

// Export all icons
async function run() {
    await iconify_tools.exportToDirectory(iconSet, {
        target: out_dir,
        log: true,
    });
}

run()