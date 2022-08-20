<script>
	/** @type {import('./$types').PageData} */
	export let data;

	import CardGrid from '$lib/components/card-grid/CardGrid.svelte';
	import Icon from '$lib/components/Icon.svelte';
	import Casing from '$lib/data/casing.json';

	const blogBase = __BLOG_BASE__;
</script>

<header>
	<h1>Categories</h1>
	<div class="tags">
		{#each data.tags as blogTag}
			<a
				class={`tag brand-${blogTag.toLowerCase()}`}
				class:capitalize={!Casing[blogTag]}
				title={Casing[blogTag] ?? blogTag}
				href={blogTag === 'all' ? blogBase : `${blogBase}/tag/${blogTag}`}
				aria-label={Casing[blogTag] ?? blogTag}
				class:active={blogTag === data.tag}
				sveltekit:prefetch
			>
				<Icon iconName={blogTag} />
				{Casing[blogTag] ?? blogTag}
			</a>
		{/each}
	</div>
</header>

{#if data.posts.length === 0}
	<h1 style="text-align:center">No posts found in selected category</h1>
{:else}
	<CardGrid Data={data.posts} showDate />
{/if}

<style lang="scss">
	@use 'sass:list';
	@import '../../../lib/styles/technologies.scss';
	@import '../../../lib/components/brand-grid/BrandStyles.scss';
	@import '../../../lib/styles/categories.scss';
	$transition-duration: 200ms;
	$all-colors: map-merge(map-merge($colors-tech, $colors-brands), $colors-blog-tags);

	@each $color-name, $color-list in $all-colors {
		.brand-#{$color-name} {
			color: list.nth($color-list, 2) !important;
			background-color: list.nth($color-list, 1) !important;
			&:hover,
			&:focus-visible,
			&.active {
				color: list.nth($color-list, 1) !important;
				background-color: list.nth($color-list, 2) !important;
			}
		}
	}

	header {
		background-color: var(--sidebar-primary-color);
		padding: 2rem;
		border-bottom-left-radius: 2rem;
		border-bottom-right-radius: 2rem;
		max-width: 90vw;
		text-align: center;
		margin-bottom: 2rem;
		> .tags {
			display: flex;
			flex-direction: row;
			column-gap: 1rem;
			row-gap: 0.5rem;
			flex-wrap: wrap;
			justify-content: center;
			margin-top: 2rem;
			> .tag {
				&.capitalize {
					text-transform: capitalize;
				}
				&:hover,
				&:focus-visible,
				&.active {
					transition-duration: $transition-duration;
					background-color: var(--accent-text);
					color: var(--accent);
				}
				color: var(--accent-text);
				background-color: var(--accent);
				transition-duration: $transition-duration;
				display: inline-flex;
				flex-direction: row;
				justify-content: center;
				align-items: center;
				column-gap: 0.5rem;
				font-weight: bold;
				border-radius: 0.25rem;
				padding: 0.2rem 0.3rem;
				line-height: 1.5;
				-webkit-box-decoration-break: clone;
				box-decoration-break: clone;
			}
		}
	}
</style>
