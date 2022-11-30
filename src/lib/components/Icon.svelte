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

	// Blog
	import faEye from '~icons/fa-solid/eye';
	import faLock from '~icons/fa-solid/lock';
	import siAndroid from '~icons/simple-icons/android';
	import siLinux from '~icons/simple-icons/linux';
	import siCSS from '~icons/simple-icons/css3';
	import siWASM from '~icons/simple-icons/webassembly';
	import siTS from '~icons/simple-icons/typescript';
	import mdiIncognito from '~icons/mdi/incognito';
	import faAward from '~icons/fa-solid/award';
	import faComment from '~icons/fa-solid/comment';
	import faBug from '~icons/fa-solid/bug';
	import faShieldAlt from '~icons/fa-solid/shield-alt';

	// Contact
	import faEmail from '~icons/fa-solid/at';
	import faGitlab from '~icons/fa-brands/gitlab';
	import faMastodon from '~icons/fa-brands/mastodon';
	import faSteam from '~icons/fa-brands/steam';
	import faTelegram from '~icons/fa-brands/telegram';
	import siMatrix from '~icons/simple-icons/matrix';
	import siCodeberg from '~icons/simple-icons/codeberg';

	// Donate
	import siPaypal from '~icons/simple-icons/paypal';
	import faGithub from '~icons/fa-brands/github';
	import siFlattr from '~icons/simple-icons/flattr';
	import siKofi from '~icons/simple-icons/kofi';

	// Custom Icons
	import cSveltePress from '~icons/custom/sveltepress';
	import cSession from '~icons/custom/session';
	import cPixelfed from '~icons/custom/pixelfed';
	import cArgyle from '~icons/custom/argyle';
	import cBeardBin from '~icons/custom/beardbin';
	import cCrycord from '~icons/custom/crycord';
	import cExorcism from '~icons/custom/exorcism';
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
	import cSaboTabby from '~icons/custom/sabotabby';

	let icons = {
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
		guide: faBook,
		npm: faNpm,
		firefox: faFirefoxBrowser,
		chromium: faChrome,
		book: faBook,
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
		gtk: mdiGNOME,
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
		flattr: siFlattr,
		'ko-fi': siKofi,

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
		codeberg: siCodeberg,

		eye: faEye,
		android: siAndroid,
		aosp: siAndroid,
		linux: siLinux,
		css: siCSS,
		wasm: siWASM,
		webassembly: siWASM,
		typescript: siTS,
		privacy: mdiIncognito,
		encryption: faLock,
		hackathon: faAward,
		ecology: faSeedling,
		opinion: faComment,
		bug: faBug,
		security: faShieldAlt,

		mastodon: faMastodon,
		steam: faSteam,
		telegram: faTelegram,
		email: faEmail,
		matrixorg: siMatrix,

		sveltepress: cSveltePress,
		session: cSession,
		pixelfed: cPixelfed,
		argyle: cArgyle,
		beardbin: cBeardBin,
		crycord: cCrycord,
		exorcism: cExorcism,
		marketvsx: cMarketVSX,
		pronounbird: cPronounBird,
		shrp: cSHRP,
		svelteglass: cSvelteGlass,
		pixelfedjs: cPixelfedJS,
		dnome: cDNOME,
		discord_tanki: cDiscordTanki,
		a11y: faA11y,
		accessibility: faA11y,
		collision: cCollision,
		sabotabby: cSaboTabby
	};

	/**
	 * Gets the correct icon from exports
	 * @param {string} icon The icon name
	 * @returns {any} The icon
	 */
	function getIcon(icon) {
		return icons[icon?.toLowerCase()] ?? null;
	}
</script>

<svelte:component
	this={getIcon(iconName)}
	class={classes}
	aria-label={`${iconName} icon`}
	style={size ? 'font-size: ' + size : null}
/>
