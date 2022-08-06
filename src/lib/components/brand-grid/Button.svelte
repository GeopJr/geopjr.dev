<script>
	export let url;
	export let provider;
	export let type;
	export let tooltip;
	export let big;
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
	<button title={tooltip} class:big class={`button ${type}`} on:click={() => shouldOpenModal()}>
		<div class="icon btn">
			<Icon size="30px" iconName={provider} />
		</div>
		<div class="content btn">{provider}</div>
	</button>
{:else}
	<a
		href={url}
		title={tooltip}
		class:big
		target="_blank"
		rel="noopener noreferrer"
		class={`button ${type}`}
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
	@import './BrandStyles.scss';

	.button {
		display: flex;
		text-decoration: none;
		color: black;
		align-content: center;
		justify-content: left;
		flex-direction: column;
		@media only screen and (min-width: 768px) {
			&.big {
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

	$transition-duration: 200ms;
	@each $color-name, $color-list in $colors-brands {
		.brand-#{$color-name} {
			color: list.nth($color-list, 2) !important;
			> .content {
				background-color: list.nth($color-list, 1) !important;
			}
			> .icon {
				background-color: subButton(list.nth($color-list, 1)) !important;
			}
		}
	}

	.brand {
		transition-duration: $transition-duration;
		filter: drop-shadow(0 0 0.2rem transparent);
		&:hover,
		&:focus-visible {
			transform: scale(1.1);
			transition-duration: $transition-duration;
		}
		&:hover {
			filter: drop-shadow(0 0 0.2rem var(--accent));
		}
	}
</style>
