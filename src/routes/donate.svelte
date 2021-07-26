<script>
	import Data from '$lib/data/donate.json';
	import BrandGrid from '$lib/components/brand-grid/BrandGrid.svelte';
</script>

<BrandGrid {Data} tooltipPrefix="Donate using" />
