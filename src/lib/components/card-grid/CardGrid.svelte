<script>
	export let Data;
	export let icons = false;

	import Card from '$lib/components/card-grid/Card.svelte';

	let sortedData =
		Data.length > 0 && Data[0].date ? Data.sort((b, a) => a.date.localeCompare(b.date)) : Data;
</script>

<div class="card-container">
	{#each sortedData as Project}
		<Card {Project} {icons} />
	{/each}
</div>

<style lang="scss">
	.card-container {
		display: grid;
		gap: 2rem;
		grid-template-columns: 1fr;
		// grid-template-rows: 1fr 1fr 1fr; // Make all heights equal
		@media only screen and (min-width: 1024px) {
			grid-template-columns: repeat(3, minmax(0, 1fr));
		}
		@media only screen and (min-width: 768px) and (max-width: 1023px) {
			grid-template-columns: repeat(2, minmax(0, 1fr));
		}
	}
</style>
