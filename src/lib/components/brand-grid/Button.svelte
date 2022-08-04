<script>
	export let url;
	export let provider;
	export let type;
	export let tooltip;
	export let chonk;
	export let showModal;

	import Icon from '$lib/components/Icon.svelte';

	/**
	 * Whether or not the link is external
	 * @returns {boolean} Whether or not the link is external
	 */
	function shouldOpenLink() {
		const ignoreList = ['http', 'mailto'];
		return (
			ignoreList.filter((ignoredListed) => url.toLowerCase().startsWith(ignoredListed)).length > 0
		);
	}

	/**
	 * Triggers a modal
	 * @returns {void}
	 */
	function shouldOpenModal() {
		showModal = {
			visible: true,
			text: url,
			provider: provider
		};
	}
</script>

{#if !shouldOpenLink()}
	<button title={tooltip} class:chonk class={'button ' + type} on:click={() => shouldOpenModal()}>
		<div class="icon btn">
			<Icon size="30px" iconName={provider} />
		</div>
		<div class="content btn">{provider}</div>
	</button>
{:else}
	<a
		href={url}
		title={tooltip}
		class:chonk
		target="_blank"
		rel="noopener noreferrer"
		class={'button ' + type}
		aria-label={tooltip}
	>
		<div class="icon">
			<Icon size="30px" iconName={provider} />
		</div>
		<div class="content">{provider}</div>
	</a>
{/if}

<style lang="scss">
	@use 'sass:list';

	.button {
		display: flex;
		text-decoration: none;
		color: black;
		align-content: center;
		justify-content: left;
		flex-direction: column;
		@media only screen and (min-width: 768px) {
			&.chonk {
				> .content {
					padding: 5rem 1rem 1rem 15rem;
				}
			}
		}
		> .icon {
			background-color: var(--accent);
			padding: 1rem;
			border-top-left-radius: 0.75rem;
			display: flex;
			flex-direction: row;
			align-items: center;
			border-bottom-left-radius: 0rem;
			border-top-right-radius: 0.75rem;
			&.btn {
				width: 100%;
			}
		}
		> .content {
			text-transform: capitalize;
			padding: 1rem 2rem;
			background-color: white;
			border-bottom-right-radius: 0.75rem;
			display: flex;
			flex-direction: row;
			align-items: center;
			font-weight: bold;
			border-top-right-radius: 0rem;
			border-bottom-left-radius: 0.75rem;
			flex-flow: row-reverse;
			padding: 1rem 1rem 1rem 6rem;
			&.btn {
				width: 100%;
			}
		}
	}

	@function subButton($color) {
		@return darken($color, 10);
	}

	$paypal: #003087;
	$ko-fi: #ff5e5b;
	$liberapay: #f6c915;
	$flattr: rgb(233, 233, 233);
	$coil: black;

	$monero: #f26822;
	$oxen: #12c7ba;

	$github: #333;
	$gitlab: #fc6d26;
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
	$codeberg: #2185D0;

	$colors-brands: (
		'paypal': (
			$paypal,
			white
		),
		'ko-fi': (
			$ko-fi,
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
		// 'linkedin': (
		// 	$linkedin,
		// 	white
		// ),
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
		'email': (
			$email,
			white
		),
		'codeberg': (
			$codeberg,
			white
		)
	);
	$transition-duration: 200ms;
	@each $color-name, $color-list in $colors-brands {
		.brand-#{$color-name} {
			color: list.nth($color-list, 2) !important;
			transition-duration: $transition-duration;
			filter: drop-shadow(0 0 0.2rem transparent);
			> .content {
				background-color: list.nth($color-list, 1) !important;
			}
			> .icon {
				background-color: subButton(list.nth($color-list, 1)) !important;
			}
			&:hover,
			&:focus-visible {
				transform: scale(1.1);
				transition-duration: $transition-duration;
			}
			&:hover {
				filter: drop-shadow(0 0 0.2rem var(--accent));
			}
		}
	}
</style>
