<script>
	export let url;
	export let provider;
	export let type;
	export let tooltip;
	export let chonk;
	export let showModal;

	import Icon from '$lib/Icon.svelte';

	function shouldOpenLink() {
		const ignoreList = ['http', 'mailto'];
		return (
			ignoreList.filter((ignoredListed) => url.toLowerCase().startsWith(ignoredListed)).length > 0
		);
	}

	function shouldOpenModal() {
		if (shouldOpenLink()) return;
		showModal = {
			visible: true,
			text: url,
			provider: provider
		};
	}

</script>

<a
	href={shouldOpenLink() ? url : ''}
	title={tooltip}
	class:chonk
	target="_blank"
	rel="noopener noreferrer"
	class={'button ' + type}
	on:click={() => shouldOpenModal()}
>
	<div class="icon">
		<Icon size="30px" iconName={provider} />
	</div>
	<div class="content">{provider}</div>
</a>

<style lang="scss">
	@use 'sass:list';

	.button {
		display: flex;
		text-decoration: none;
		color: black;
		align-content: center;
		justify-content: center;
		@media only screen and (min-width: 768px) {
			&.chonk {
				flex-direction: column;
				> .icon {
					border-bottom-left-radius: 0rem;
					border-top-right-radius: 0.75rem;
				}
				> .content {
					border-top-right-radius: 0rem;
					border-bottom-left-radius: 0.75rem;
					flex-flow: row-reverse;
					padding: 5rem 1rem 1rem 15rem;
				}
			}
		}
		> .icon {
			background-color: var(--accent);
			padding: 1rem;
			border-top-left-radius: 0.75rem;
			border-bottom-left-radius: 0.75rem;
			display: flex;
			flex-direction: row;
			align-items: center;
		}
		> .content {
			text-transform: capitalize;
			padding: 1rem 2rem;
			background-color: white;
			border-top-right-radius: 0.75rem;
			border-bottom-right-radius: 0.75rem;
			display: flex;
			flex-direction: row;
			align-items: center;
			font-weight: bold;
		}
	}

	@function subButton($color) {
		@return darken($color, 10);
	}

	$paypal: #003087;
	$patreon: #f96854;
	$ko-fi: #29abe0;
	$liberapay: #f6c915;
	$flattr: rgb(233, 233, 233);
	$coil: black;

	$monero: #f26822;
	$oxen: #12c7ba;

	$github: #333;
	$gitlab: #fc6d26;
	$bitbucket: #2684ff;
	$discord: #5865f2;
	$keybase: #ff6f21;
	$linkedin: #0077b5;
	$mastodon: #4ea2df;
	$matrixorg: black;
	$pixelfed: rgb(233, 233, 233);
	$session: #00f782;
	$steam: #171a21;
	$telegram: #0088cc;
	$twitter: #1da1f2;
	$email: #76bb21;

	$colors-brands: (
		'paypal': (
			$paypal,
			white
		),
		'patreon': (
			$patreon,
			white
		),
		'ko-fi': (
			$ko-fi,
			white
		),
		'liberapay': (
			$liberapay,
			black
		),
		'coil': (
			$coil,
			white
		),
		'flattr': (
			$flattr,
			black
		),
		'monero': (
			$monero,
			white
		),
		'oxen': (
			$oxen,
			black
		),
		'github': (
			$github,
			white
		),
		'gitlab': (
			$gitlab,
			white
		),
		'bitbucket': (
			$bitbucket,
			white
		),
		'discord': (
			$discord,
			white
		),
		'linkedin': (
			$linkedin,
			white
		),
		'mastodon': (
			$mastodon,
			white
		),
		'matrixorg': (
			$matrixorg,
			white
		),
		'pixelfed': (
			$pixelfed,
			black
		),
		'session': (
			$session,
			black
		),
		'steam': (
			$steam,
			white
		),
		'telegram': (
			$telegram,
			white
		),
		'twitter': (
			$twitter,
			white
		),
		'keybase': (
			$keybase,
			white
		),
		'email': (
			$email,
			white
		)
	);

	@each $color-name, $color-list in $colors-brands {
		.brand-#{$color-name} {
			color: list.nth($color-list, 2) !important;
			transition-duration: 200ms;
			> .content {
				background-color: list.nth($color-list, 1) !important;
			}
			> .icon {
				background-color: subButton(list.nth($color-list, 1)) !important;
			}
			&:hover,
			&:focus-visible {
				transform: scale(1.1);
				transition-duration: 200ms;
			}
		}
	}

</style>
