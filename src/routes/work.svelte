<script>
	import Data from '$lib/data/work.json';
	import CardGrid from '$lib/components/card-grid/CardGrid.svelte';
	import Banner from '$lib/components/Banner.svelte';
</script>

<Banner>
	You can find most of my FLOSS projects on my <a
		href="https://github.com/GeopJr"
		target="_blank"
		rel="noopener noreferrer">GitHub Profile</a
	>.
</Banner>
<CardGrid {Data} icons />
