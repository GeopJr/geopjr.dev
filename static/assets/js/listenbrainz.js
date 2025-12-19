const details = document.querySelector("footer details");
details.addEventListener('toggle', on_details_toggled);
details.addEventListener('toggle', on_details_toggled_scroll);

function addRow(label, value) {
	const p = document.createElement("p")

	const key = document.createElement("span")
	key.className = "label"
	key.textContent = label + ": "

	const val = document.createElement("span")
	val.className = "value"
	val.textContent = value

	p.append(key, val)
    return p
}

function on_details_toggled_scroll() {
    if (details.open) details.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

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

                        const win = document.createElement("article")
                        win.className = "card"
                        win.innerHTML = `<header><img aria-hidden="true" alt="" src="/assets/images/tango/banshee.webp"><span>Last Scrobble</span><div class="window-controls" aria-hidden="true"><span></span><span></span><span></span></div></header>`
                        const sec = document.createElement("section")
                        win.appendChild(sec)

                        if (art != "") {
                            const img = document.createElement("img")
                            img.src = art
                            img.alt = ""
                            sec.appendChild(img)
                        }

                        const title_div = document.createElement("article")
                        title_div.className = "frame keyval"
                        
                        {
                            const header = document.createElement("header")
                            header.textContent = "Info"
                            title_div.appendChild(header)
                        }

                        title_div.append(
                            addRow("Track", track),
                            addRow("Artist", artist)
                        )
                        if (album != "") title_div.appendChild(addRow("Album", album))

                        let timestamp = x?.payload?.latest_listen_ts ?? scrobble.listened_at
                        if (timestamp > 1000) {
                            timestamp = (new Date(timestamp * 1000)).toISOString().split("T")
                            if (timestamp.length > 1) timestamp[1] = timestamp[1].slice(0, -5)
                            timestamp = timestamp.join(" ")
                            const tmstamp = addRow("Date", timestamp)
                            tmstamp.classList.add("timestamp")
                            title_div.appendChild(tmstamp)
                        }
                        sec.appendChild(title_div)

                        listenbrainz.appendChild(win)
                    }
                }
            }
        })
}
