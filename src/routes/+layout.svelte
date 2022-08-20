<script>
	import '../global.scss';
	import Sidebar from '$lib/components/Sidebar.svelte';
	import Theme from '$lib/components/Theme.svelte';
	import { page } from '$app/stores';
	import { blur } from 'svelte/transition';

	const routes = {
		'/': {
			title: 'Home',
			desc: 'Personal Portfolio - CS @ NKUA - Ethical Tech - Blogs about programming, tech, ethics, climate & more'
		},
		'/about': { title: 'About', icon: 'user', desc: 'About GeopJr - Who I am and what I do' },
		'/work': {
			title: 'Work',
			icon: 'briefcase',
			desc: "GeopJr's projects - Stuff I've made"
		},
		'/blog': {
			title: 'Blog',
			icon: 'book',
			desc: "GeopJr's blog - Posts about tech, climate, ethics & more"
		},
		'/donate': {
			title: 'Donate',
			icon: 'donate',
			desc: 'Donate to GeopJr - Help me continue my FOSS work'
		},
		'/contact': {
			title: 'Contact',
			icon: 'address-card',
			desc: 'Contact GeopJr - Send me a message'
		}
	};

	$: currentPage = $page.url.pathname.toLowerCase();
	$: isBlogTag = __BLOG_TAG_SLUG__.some((str) => currentPage.startsWith(`/blog/${str}/`));
	$: pageTitle = routes[isBlogTag ? '/blog' : currentPage]?.title ?? 'Error';
	$: isBlogPost = currentPage.startsWith('/blog/') && !isBlogTag;
</script>

<svelte:head>
	{#if !isBlogPost}
		<title>{pageTitle} - GeopJr</title>
		<meta name="title" content={pageTitle + '- GeopJr'} />
		<meta name="description" content={routes[currentPage]?.desc ?? 'This page does not exist'} />
		<link rel="canonical" href={'https://geopjr.dev' + currentPage} />
		<meta name="og:title" content={pageTitle + '- GeopJr'} />
		<meta name="og:description" content={routes[currentPage]?.desc ?? 'This page does not exist'} />
		<meta name="og:url" content={'https://geopjr.dev/' + currentPage} />
		<meta property="twitter:title" content={pageTitle + '- GeopJr'} />
		<meta property="twitter:url" content={'https://geopjr.dev/' + currentPage} />
		<meta
			property="twitter:description"
			content={routes[currentPage]?.desc ?? 'This page does not exist'}
		/>
	{/if}
</svelte:head>

<Theme />
<Sidebar
	{currentPage}
	shouldHighlight={isBlogPost || isBlogTag || pageTitle !== 'Error'}
	routes={Object.fromEntries(Object.entries(routes).filter(([x]) => x !== '/'))}
/>
<main>
	{#key pageTitle}
		<div
			class="container"
			style={(currentPage === '/blog' || isBlogTag) && pageTitle !== 'Error'
				? 'padding-top: 0rem;justify-content: start;'
				: null}
			in:blur={{ duration: isBlogPost ? 0 : 500 }}
		>
			<slot />
		</div>
	{/key}
</main>

<style lang="scss">
	main {
		position: relative;
		z-index: 10;
	}
	.container {
		padding: 4rem 0;
		display: flex;
		flex-direction: column;
		justify-content: space-around;
		margin: auto;
		align-items: center;
		min-height: 100vh;
		width: 80vw;
		color: var(--text-color);
		@media only screen and (min-width: 768px) {
			padding-left: 4rem !important;
			@media only screen and (max-height: 910px) {
				padding: 1rem 0;
			}
		}
	}
</style>
