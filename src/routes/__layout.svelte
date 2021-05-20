<script>
	import '../global.scss';
	import Sidebar from '$lib/layout/Sidebar.svelte';
	import Theme from '$lib/Theme.svelte';
	import { page } from '$app/stores';

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
</svelte:head>

<Theme />
<Sidebar {currentPage} {routes} />
<div class="container">
	<slot />
</div>

<style lang="scss">
	.container {
		padding-top: 4rem;
		padding-bottom: 4rem;
		display: flex;
		flex-direction: column;
		justify-content: space-around;
		margin: auto;
		align-items: center;
		min-height: 100vh;
		width: 80vw;
		color: var(--text-color);
		@media only screen and (min-width: 768px) {
			padding-left: 4rem;
		}
	}

</style>
