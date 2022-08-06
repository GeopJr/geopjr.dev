<script context="module">
	export async function load({ params }) {
		const slug = params.slug.replaceAll(' ', '').replace(/\/\/+/g, '/');
		const parts = slug.split('/').filter((n) => n && n !== '');

		if (slug === '') {
			return {
				status: 200,
				props: {
					tag: ''
				}
			};
		} else if (
			parts.length > 2 ||
			parts.length === 0 ||
			!__BLOG_TAG_SLUG__.includes(parts[0].toLowerCase())
		) {
			return {
				status: 301,
				redirect: '/blog'
			};
		}
		return {
			status: 200,
			props: {
				tag: `${parts[1]?.toLowerCase() ?? ''}`
			}
		};
	}
</script>

<script>
	export let tag;

	import CardGrid from '$lib/components/card-grid/CardGrid.svelte';
	import Icon from '$lib/components/Icon.svelte';
	import Casing from '$lib/data/casing.json';

	const modules = import.meta.glob('./*.md', { eager: true, import: 'metadata' });
	const blogBase = '/blog';
	const posts = [];
	let tags = [];

	for (const path in modules) {
		const metadata = modules[path];
		const slug = path.split('.').slice(0, -1).join('.').substring(1);

		const post = {
			name: metadata.title,
			desc: metadata.subtitle,
			date: metadata.updated?.split('T')[0] ?? metadata.date?.split('T')[0],
			techs: metadata.tags,
			links: [
				{
					icon: 'eye',
					url: `${blogBase}${slug}`,
					tooltip: 'Read More'
				}
			]
		};

		posts.push(post);
		tags = tags.concat(metadata.tags);
	}

	tags = tags.map((x) => x.toLowerCase()).sort();
	tags = ['all', ...new Set(tags)];

	$: Data = tag
		? posts.filter((x) => x.techs.map((x) => x.toLowerCase()).includes(tag.toLowerCase()))
		: posts;
	$: filteredTags =
		tag && tag.toLowerCase() !== 'all'
			? tags.filter((x) => x.toLowerCase() !== tag)
			: tags.slice(1);
</script>

<header>
	<h1>Categories</h1>
	<div class="tags">
		{#each filteredTags as blogTag}
			<a
				class={`tag brand-${blogTag.toLowerCase()}`}
				class:capitalize={!Casing[blogTag]}
				title={Casing[blogTag] ?? blogTag}
				href={blogTag === 'all' ? blogBase : `${blogBase}/tag/${blogTag}`}
				aria-label={Casing[blogTag] ?? blogTag}
				sveltekit:prefetch
			>
				<Icon iconName={blogTag} />
				{Casing[blogTag] ?? blogTag}
			</a>
		{/each}
	</div>
</header>

{#if Data.length === 0}
	<h1 style="text-align:center">No posts found in selected category</h1>
{:else}
	<CardGrid {Data} showDate />
{/if}

<style lang="scss">
	@use 'sass:list';
	@import '../../lib/styles/technologies.scss';
	@import '../../lib/components/brand-grid/BrandStyles.scss';
	@import '../../lib/styles/categories.scss';
	$transition-duration: 200ms;
	$all-colors: map-merge(map-merge($colors-tech, $colors-brands), $colors-blog-tags);

	@each $color-name, $color-list in $all-colors {
		.brand-#{$color-name} {
			color: list.nth($color-list, 2) !important;
			background-color: list.nth($color-list, 1) !important;
			&:hover,
			&:focus-visible {
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
				&:focus-visible {
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
