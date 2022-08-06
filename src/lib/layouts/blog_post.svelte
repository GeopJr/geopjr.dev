<script>
	export let title;
	export let subtitle;
	export let date;
	export let updated;
	export let tags;

	import { page } from '$app/stores';
	import Icon from '$lib/components/Icon.svelte';

	$: currentPage = $page.url.href;

	/**
	 * Converts ISO date to YYYY-MM-DD
	 * @param full_date ISO date string
	 * @returns {String} YYYY-MM-DD
	 */
	function formatDate(full_date) {
		return full_date.split('T')[0];
	}
</script>

<svelte:head>
	<title>{title} - GeopJr</title>
	<meta name="title" content={title + '- GeopJr'} />
	{#if subtitle}
		<meta name="description" content={subtitle} />
		<meta name="og:description" content={subtitle} />
		<meta property="twitter:description" content={subtitle} />
	{/if}
	<link rel="canonical" href={currentPage} />
	<meta name="og:title" content={title + '- GeopJr'} />
	<meta name="og:url" content={currentPage} />
	<meta property="twitter:title" content={title + '- GeopJr'} />
	<meta property="twitter:url" content={currentPage} />
</svelte:head>

<article>
	<header class="blog-header">
		<div class="blog-titles">
			<h1 class="blog-title">{title}</h1>
			{#if subtitle}
				<h2 class="blog-subtitle">{subtitle}</h2>
			{/if}
		</div>
		<div class="blog-extra">
			{#if tags && typeof tags === 'object' && tags.length > 0}
				<div class="blog-tags">
					{#each tags as tag}
						<Icon classes="blog-tag" iconName={tag} />
					{/each}
				</div>
			{/if}
			<div class="blog-date">
				<p class="date">Posted on: {formatDate(date)}</p>
				{#if updated}
					<p class="date">Updated on: {formatDate(updated)}</p>
				{/if}
			</div>
		</div>
	</header>
	<div class="blog-content">
		<slot />
	</div>
</article>

<style lang="scss">
	@import './blog_post.scss';
	@import '../styles/prism-dark.css';
	@import '../styles/prism-light.css';
</style>
