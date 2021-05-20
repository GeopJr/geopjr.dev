<script>
	import '../global.scss';
	import Sidebar from '$lib/layout/Sidebar.svelte';
	import Theme from '$lib/Theme.svelte';
	import { page } from '$app/stores';
	import { blur } from 'svelte/transition';

	const routes = {
		'/': 'Home',
		'/work': 'Work',
		'/blog': 'Blog',
		'/donate': 'Donate',
		'/contact': 'Contact'
	};

	$: currentPage = $page.path.toLowerCase();
	$: pageTitle = routes[currentPage] ?? 'Error';

</script>

<svelte:head>
	<title>{pageTitle} - GeopJr</title>
	<meta name="og:title" content="{pageTitle} - GeopJr" />
	<link rel="canonical" href={'https://geopjr.dev' + currentPage} />
</svelte:head>

<Theme />
<Sidebar {currentPage} {routes} />
<main>
	{#key pageTitle}
		<div class="container" in:blur={{ duration: 666 }}>
			<slot />
		</div>
	{/key}
</main>

<style lang="scss">
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
