const flags = ["flag_agender", "flag_earth", "flag_ancom", "flag_anqueer", "flag_gay", "flag_nb", "flag_trans"]

document.getElementById("error_image").src = `/assets/icons/${flags[Math.floor(Math.random() * flags.length)]}.svg`;