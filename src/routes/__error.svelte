<script context="module">
	export function load({ error, status }) {
		return {
			props: {
				title: `${status}: ${error.message}`
			}
		};
	}

</script>

<script>
	export let title;
	console.error(title);
	$: error = title.length > 30 ? title.substring(0, 33) + '...' : title;

</script>

<div class="error">
	<img src="/images/error.svg" alt="" class="flag" />
	<h1 class="errorMsg">{error}</h1>
</div>

<style lang="scss">
	.error {
		text-align: center;
	}

	.flag {
		max-height: 50vh;
		max-width: 50vh;
		border-radius: 2rem;
	}
	.errorMsg {
		border-radius: 0.25rem;
		background-color: var(--sidebar-secondary-color);
		padding: 0 1rem;
		margin-top: 2rem;
		transition-duration: 300ms;
		&:hover {
			transition-duration: 300ms;
			border-radius: 2rem;
		}
	}

</style>
