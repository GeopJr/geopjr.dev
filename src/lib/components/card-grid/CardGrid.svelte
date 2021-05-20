<script>
	export let Data;

	import Card from '$lib/components/card-grid/Card.svelte';

	let sortedData =
		Data.length > 0 && Data[0].date ? Data.sort((b, a) => a.date.localeCompare(b.date)) : Data;

	// TODO: infinite scrolling if data exceeds 20 cards

</script>

<div class="card-container">
	{#each sortedData as Project}
		<Card {Project} />
	{/each}
</div>

<style lang="scss">
	.card-container {
		display: grid;
		gap: 30px;
		grid-template-columns: 1fr;
		// grid-template-rows: 1fr 1fr 1fr; // Make all heights equal
		@media (min-width: 1024px) {
			padding: 4rem 0;
			grid-template-columns: 1fr 1fr 1fr;
		}
		@media (min-width: 768px) and (max-width: 1023px) {
			padding: 4rem 0;
			grid-template-columns: 1fr 1fr;
		}
	}

</style>
