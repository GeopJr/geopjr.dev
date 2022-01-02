<script>
	export let iconName;
	export let size = '';
	export let classes = '';

	// Index + Sidebar
	import twWave from '~icons/twemoji/waving-hand';
	import faBriefcase from '~icons/fa-solid/briefcase';
	import faBook from '~icons/fa-solid/book';
	import faDonate from '~icons/fa-solid/donate';
	import faAddressCard from '~icons/fa-solid/address-card';
	import faSun from '~icons/fa-solid/sun';
	import faMoon from '~icons/fa-solid/moon';
	import faAdjust from '~icons/fa-solid/adjust';
	import faCircle from '~icons/fa-solid/circle';
	import faBars from '~icons/fa-solid/bars';
	import faUser from '~icons/fa-solid/user';
	import mdiPentagram from '~icons/mdi/pentagram';

	// Modal
	import faTimes from '~icons/fa-solid/times';
	import faCopy from '~icons/fa-solid/copy';

	// About + Work
	import siNativeScript from '~icons/simple-icons/nativescript';
	import siCapacitor from '~icons/simple-icons/capacitor';
	import siElixir from '~icons/simple-icons/elixir';
	import siRuby from '~icons/simple-icons/ruby';
	import siPhp from '~icons/simple-icons/php';
	import siQuasar from '~icons/simple-icons/quasar';
	import siFlutter from '~icons/simple-icons/flutter';
	import siDart from '~icons/simple-icons/dart';
	import siCrystal from '~icons/simple-icons/crystal';
	import siVue from '~icons/simple-icons/vuejs';
	import siSvelte from '~icons/simple-icons/svelte';
	import siElectron from '~icons/simple-icons/electron';
	import siJs from '~icons/simple-icons/javascript';
	import siScss from '~icons/simple-icons/sass';
	import siLess from '~icons/simple-icons/less';
	import siNode from '~icons/simple-icons/nodejs';
	import mdiGNOME from '~icons/mdi/gnome';
	import mdiROR from '~icons/mdi/language-ruby-on-rails';
	import siQt from '~icons/simple-icons/qt';
	import siNuxt from '~icons/simple-icons/nuxt-dot-js';
	import siVuetify from '~icons/simple-icons/vuetify';
	import siExpress from '~icons/simple-icons/express';
	import siMaterialDesign from '~icons/simple-icons/materialdesign';
	import siWindi from '~icons/simple-icons/windicss';
	import faPhoenix from '~icons/fa-brands/phoenix-framework';
	import faA11y from '~icons/fa-solid/universal-access';
	import faSeedling from '~icons/fa-solid/seedling';
	import faDocker from '~icons/fa-brands/docker';

	import siVite from '~icons/simple-icons/vite';
	import faGithubAlt from '~icons/fa-brands/github-alt';
	import faNpm from '~icons/fa-brands/npm';
	import faChrome from '~icons/fa-brands/chrome';
	import faFirefoxBrowser from '~icons/fa-brands/firefox-browser';
	import siFlathub from '~icons/simple-icons/flathub';
	import faExternalLinkAlt from '~icons/fa-solid/external-link-alt';

	// Contact
	import faEmail from '~icons/fa-solid/at';
	import faDev from '~icons/fa-brands/dev';
	import faGitlab from '~icons/fa-brands/gitlab';
	import faBitbucket from '~icons/fa-brands/bitbucket';
	import faDiscord from '~icons/fa-brands/discord';
	import faMastodon from '~icons/fa-brands/mastodon';
	import faSteam from '~icons/fa-brands/steam';
	import faTelegram from '~icons/fa-brands/telegram';
	import faTwitter from '~icons/fa-brands/twitter';
	import siMatrix from '~icons/simple-icons/matrix';

	// Donate
	import siPaypal from '~icons/simple-icons/paypal';
	import faPatreon from '~icons/fa-brands/patreon';
	import faMonero from '~icons/fa-brands/monero';
	import faGithub from '~icons/fa-brands/github';
	import siFlattr from '~icons/simple-icons/flattr';
	import siLiberapay from '~icons/simple-icons/liberapay';

	// Custom Icons
	import cSveltePress from '~icons/custom/sveltepress';
	import cSession from '~icons/custom/session';
	import cOxen from '~icons/custom/oxen';
	import cPixelfed from '~icons/custom/pixelfed';
	import cArgyle from '~icons/custom/argyle';
	import cBeardBin from '~icons/custom/beardbin';
	import cCrycord from '~icons/custom/crycord';
	import cExorcism from '~icons/custom/exorcism';
	// import cHashbrown from '~icons/custom/hashbrown';
	import cCollision from '~icons/custom/collision';
	import cMarketVSX from '~icons/custom/marketvsx';
	import cPronounBird from '~icons/custom/pronounbird';
	import cSHRP from '~icons/custom/shrp';
	import cSvelteGlass from '~icons/custom/svelteglass';
	import cPixelfedJS from '~icons/custom/pixelfedjs';
	import cDNOME from '~icons/custom/dnome';
	import cDiscordTanki from '~icons/custom/discord_tanki';
	import cVitePluginDart from '~icons/custom/viteplugindart';
	import cLibadwaitacr from '~icons/custom/libadwaitacr';
	import cShipwreck from '~icons/custom/shipwreck';

	const icons = {
		viteplugindart: cVitePluginDart,
		libadwaitacr: cLibadwaitacr,
		shipwreck: cShipwreck,
		ror: mdiROR,
		phoenix: faPhoenix,
		pentagram: mdiPentagram,
		wavinghand: twWave,
		website: faExternalLinkAlt,
		github: faGithub,
		githubalt: faGithubAlt,
		flathub: siFlathub,
		docs: faBook,
		npm: faNpm,
		firefox: faFirefoxBrowser,
		chromium: faChrome,
		dev: faDev,
		book: faBook,
		windi: siWindi,
		seedling: faSeedling,
		docker: faDocker,

		flutter: siFlutter,
		dart: siDart,
		crystal: siCrystal,
		vuejs: siVue,
		svelte: siSvelte,
		electron: siElectron,

		javascript: siJs,
		sass: siScss,
		less: siLess,
		nodejs: siNode,
		gnome: mdiGNOME,
		qt: siQt,
		nuxt: siNuxt,
		vuetify: siVuetify,
		express: siExpress,
		materialdesign: siMaterialDesign,

		vite: siVite,
		nativescript: siNativeScript,
		capacitor: siCapacitor,
		elixir: siElixir,
		ruby: siRuby,
		php: siPhp,
		quasar: siQuasar,

		paypal: siPaypal,
		patreon: faPatreon,
		monero: faMonero,
		flattr: siFlattr,
		liberapay: siLiberapay,

		user: faUser,
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

		mastodon: faMastodon,
		steam: faSteam,
		telegram: faTelegram,
		twitter: faTwitter,
		email: faEmail,
		matrixorg: siMatrix,

		sveltepress: cSveltePress,
		session: cSession,
		oxen: cOxen,
		pixelfed: cPixelfed,
		argyle: cArgyle,
		beardbin: cBeardBin,
		crycord: cCrycord,
		exorcism: cExorcism,
		// hashbrown: cHashbrown,
		marketvsx: cMarketVSX,
		pronounbird: cPronounBird,
		shrp: cSHRP,
		svelteglass: cSvelteGlass,
		pixelfedjs: cPixelfedJS,
		dnome: cDNOME,
		discord_tanki: cDiscordTanki,
		a11y: faA11y,
		collision: cCollision
	};

	/**
	 * Gets the correct icon from exports
	 * @param {string} icon The icon name
	 * @returns {any} The icon
	 */
	function getIcon(icon) {
		return icons[icon.toLowerCase()] ?? null;
	}
</script>

<svelte:component
	this={getIcon(iconName)}
	class={classes}
	style={size ? 'font-size: ' + size : null}
/>
