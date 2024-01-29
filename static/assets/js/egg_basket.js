/**
 * @param {string} js_file 
 */
const load_js = (js_file) => {
    const x = document.createElement("script")
    x.src = `/assets/js/${js_file}.js`
    document.querySelector("html").append(x)
    return x
}

const eggs = ["omori"]
// Only load egg.js when it's not mobile and doesn't prefer reduced motion for the sake of saving bandwidth.
if ([window.matchMedia("(max-width:600px)"), window.matchMedia("(prefers-reduced-motion)")].filter(x => x.matches).length == 0) {
    load_js("egg").onload = () => {eggs.forEach(x => load_js(`egg/${x}`))}
}
