<script>
	import Data from '$lib/data/contact.json';
	import BrandGrid from '$lib/components/brand-grid/BrandGrid.svelte';

</script>

<BrandGrid {Data} tooltipPrefix="Contact me on" />
