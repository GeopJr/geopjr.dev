const runIdle = (cb, timeout = 2000) => {
    if ("requestIdleCallback" in window) {
        requestIdleCallback(cb, { timeout })
    } else {
        setTimeout(cb, 1)
    }
}

runIdle(() => {
    const eggs = ["omori"]
    // Only load egg.js when it's not mobile and doesn't prefer reduced motion for the sake of saving bandwidth.
    if (![window.matchMedia("(max-width:600px)"), window.matchMedia("(prefers-reduced-motion)")].some(x => x.matches)) {
        eggs.forEach(x => import(`/assets/js/egg/${x}.js`))
    }
})
