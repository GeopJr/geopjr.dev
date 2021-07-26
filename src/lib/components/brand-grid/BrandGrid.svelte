<script>
	export let Data;
	export let tooltipPrefix;

	import Button from '$lib/components/brand-grid/Button.svelte';
	import Modal from '$lib/components/Modal.svelte';

	function capitalize(text) {
		return text.charAt(0).toUpperCase() + text.slice(1);
	}

	let showModal = {
		visible: false,
		text: '',
		provider: ''
	};
</script>

<Modal
	visible={showModal.visible}
	text={showModal.text}
	provider={capitalize(showModal.provider)}
/>
<div class="button-container">
	{#each Object.entries(Data) as [provider, url]}
		<Button
			type={'brand-' + provider}
			{provider}
			{url}
			tooltip={tooltipPrefix + ' ' + capitalize(provider)}
			chonk={true}
			bind:showModal
		/>
	{/each}
</div>

<style lang="scss">
	.button-container {
		display: grid;
		grid-template-columns: 1fr;
		gap: 1rem;
		// 1242 instead of 1024 this time due to size
		@media only screen and (min-width: 1242px) {
			grid-template-columns: 1fr 1fr 1fr;
			gap: 5rem;
		}
		@media only screen and (min-width: 768px) and (max-width: 1241px) {
			grid-template-columns: 1fr 1fr;
		}
	}
</style>
