const details = document.querySelector("footer details");
details.addEventListener('toggle', on_details_toggled);
function on_details_toggled() {
    const listenbrainz = document.querySelector("footer details .listenbrainz")
    if (listenbrainz.dataset.loaded == "true" || !details.open) return
    details.removeEventListener('toggle', on_details_toggled)

    fetch("https://api.listenbrainz.org/1/user/GeopJr/listens?count=1")
        .then(x => x.json())
        .then(x => {
            if (x?.payload?.listens?.length > 0) {
                const scrobble = x.payload.listens[0]
                if (scrobble?.track_metadata) {
                    const album = scrobble.track_metadata.release_name ?? ""
                    const track = scrobble.track_metadata.track_name ?? ""
                    const artist = scrobble.track_metadata.artist_name ?? ""
                    const art = !!scrobble.track_metadata.mbid_mapping?.caa_release_mbid ? `https://coverartarchive.org/release/${scrobble.track_metadata.mbid_mapping.caa_release_mbid}/front-250.jpg` : ""

                    if (artist != "" && track != "") {
                        listenbrainz.dataset.loaded = "true"

                        let p = document.createElement("p")
                        p.textContent = "Last Scrobble"
                        listenbrainz.appendChild(p)

                        if (art != "") {
                            const img = document.createElement("img")
                            img.src = art
                            img.alt = ""
                            listenbrainz.appendChild(img)
                        }

                        const title_div = document.createElement("div")
                        p = document.createElement("p")
                        p.textContent = track
                        p.title = track
                        title_div.appendChild(p)

                        p = document.createElement("p")
                        p.textContent = artist
                        p.title = artist
                        title_div.appendChild(p)

                        if (album != "") {
                            p = document.createElement("p")
                            p.textContent = album
                            p.title = album
                            title_div.appendChild(p)
                        }

                        let timestamp = x?.payload?.latest_listen_ts ?? scrobble.listened_at
                        if (timestamp > 1000) {
                            timestamp = (new Date(timestamp * 1000)).toISOString().split("T")
                            if (timestamp.length > 1) timestamp[1] = timestamp[1].slice(0, -5)
                            timestamp = timestamp.join(" ")
                            p = document.createElement("p")
                            p.classList.add("timestamp")
                            p.textContent = timestamp
                            title_div.appendChild(p)
                        }

                        listenbrainz.appendChild(title_div)
                    }
                }
            }
        })
}
