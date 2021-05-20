<script>
	export let iconName;
	export let size;
	export let classes;

	import IconifyIcon from '@iconify/svelte';

	import twWave from '@iconify-icons/twemoji/waving-hand';

	import faBriefcase from '@iconify-icons/fa-solid/briefcase';
	import faDonate from '@iconify-icons/fa-solid/donate';
	import faAddressCard from '@iconify-icons/fa-solid/address-card';
	import faSun from '@iconify-icons/fa-solid/sun';
	import faMoon from '@iconify-icons/fa-solid/moon';
	import faAdjust from '@iconify-icons/fa-solid/adjust';
	import faCircle from '@iconify-icons/fa-solid/circle';
	import faTimes from '@iconify-icons/fa-solid/times';
	import faBars from '@iconify-icons/fa-solid/bars';
	import faEmail from '@iconify-icons/fa-solid/at';
	import faCopy from '@iconify-icons/fa-solid/copy';

	import siPaypal from '@iconify-icons/simple-icons/paypal';
	import faPatreon from '@iconify-icons/fa-brands/patreon';
	import faMonero from '@iconify-icons/fa-brands/monero';
	import faGithub from '@iconify-icons/fa-brands/github';
	import faGithubAlt from '@iconify-icons/fa-brands/github-alt';
	import faNpm from '@iconify-icons/fa-brands/npm';
	import faChrome from '@iconify-icons/fa-brands/chrome';
	import faFirefoxBrowser from '@iconify-icons/fa-brands/firefox-browser';
	import faDev from '@iconify-icons/fa-brands/dev';
	import faGitlab from '@iconify-icons/fa-brands/gitlab';
	import faBitbucket from '@iconify-icons/fa-brands/bitbucket';
	import faDiscord from '@iconify-icons/fa-brands/discord';
	import faKeybase from '@iconify-icons/fa-brands/keybase';
	import faMastodon from '@iconify-icons/fa-brands/mastodon';
	import faSteam from '@iconify-icons/fa-brands/steam';
	import faTelegram from '@iconify-icons/fa-brands/telegram';
	import faTwitter from '@iconify-icons/fa-brands/twitter';

	import faExternalLinkAlt from '@iconify-icons/fa-solid/external-link-alt';
	import faCube from '@iconify-icons/fa-solid/cube';
	import faBook from '@iconify-icons/fa-solid/book';

	import siCrystal from '@iconify-icons/simple-icons/crystal';
	import siVue from '@iconify-icons/simple-icons/vuejs';
	import siSvelte from '@iconify-icons/simple-icons/svelte';
	import siElectron from '@iconify-icons/simple-icons/electron';
	import siHtml from '@iconify-icons/simple-icons/html5';
	import siCss from '@iconify-icons/simple-icons/css3';
	import siJs from '@iconify-icons/simple-icons/javascript';
	import siScss from '@iconify-icons/simple-icons/sass';
	import siLess from '@iconify-icons/simple-icons/less';
	import siNode from '@iconify-icons/simple-icons/nodejs';
	import siGtk from '@iconify-icons/simple-icons/gnome';
	import siQt from '@iconify-icons/simple-icons/qt';
	import siNuxt from '@iconify-icons/simple-icons/nuxt-dot-js';
	import siVuetify from '@iconify-icons/simple-icons/vuetify';
	import siExpress from '@iconify-icons/simple-icons/express';
	import siMaterialDesign from '@iconify-icons/simple-icons/materialdesign';
	import siMongoDb from '@iconify-icons/simple-icons/mongodb';
	import siFlattr from '@iconify-icons/simple-icons/flattr';
	import siLiberapay from '@iconify-icons/simple-icons/liberapay';
	import siKoFi from '@iconify-icons/simple-icons/ko-fi';
	import siMatrix from '@iconify-icons/simple-icons/matrix';

	import cSession from '$lib/logos/session.svg';
	import cOxen from '$lib/logos/oxen.svg';
	import cCoil from '$lib/logos/coil.svg';
	import cPixelfed from '$lib/logos/pixelfed.svg';

	const icons = {
		wavinghand: twWave,

		website: faExternalLinkAlt,
		github: faGithub,
		githubalt: faGithubAlt,
		flathub: faCube,
		docs: faBook,
		npm: faNpm,
		firefox: faFirefoxBrowser,
		chromium: faChrome,
		dev: faDev,

		crystal: siCrystal,
		vuejs: siVue,
		svelte: siSvelte,
		electron: siElectron,
		html5: siHtml,
		css3: siCss,
		javascript: siJs,
		sass: siScss,
		less: siLess,
		nodejs: siNode,
		gnome: siGtk,
		qt: siQt,
		nuxt: siNuxt,
		vuetify: siVuetify,
		express: siExpress,
		materialdesign: siMaterialDesign,
		mongodb: siMongoDb,

		paypal: siPaypal,
		patreon: faPatreon,
		monero: faMonero,
		flattr: siFlattr,
		liberapay: siLiberapay,
		'ko-fi': siKoFi,

		briefcase: faBriefcase,
		donate: faDonate,
		'address-card': faAddressCard,
		sun: faSun,
		moon: faMoon,
		adjust: faAdjust,
		circle: faCircle,
		times: faTimes,
		bars: faBars,
		copy: faCopy,

		gitlab: faGitlab,
		bitbucket: faBitbucket,
		discord: faDiscord,
		keybase: faKeybase,
		mastodon: faMastodon,
		steam: faSteam,
		telegram: faTelegram,
		twitter: faTwitter,
		email: faEmail,
		matrixorg: siMatrix
	};

	const staticIcons = {
		session: cSession,
		coil: cCoil,
		oxen: cOxen,
		pixelfed: cPixelfed
	};

	function getIcon(icon) {
		return (icons[icon.toLowerCase()] || staticIcons[icon.toLowerCase()]) ?? null;
	}

</script>

{#if icons[iconName.toLowerCase()]}
	<IconifyIcon class={classes} style={size ? 'font-size: ' + size : ''} icon={getIcon(iconName)} />
{:else}
	<img
		class={classes}
		style={size ? 'height: ' + size + ';width: ' + size : ''}
		src={getIcon(iconName)}
		alt=""
		draggable="false"
	/>
{/if}
