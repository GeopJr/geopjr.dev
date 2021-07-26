<script>
	export let Project;

	import Icon from '$lib/Icon.svelte';
</script>

<div class="card">
	<div class="card-title">
		<strong class="accent--block">{Project.name}</strong>
		<div class="card-badges">
			{#each Project.techs as tech}
				<Icon classes="sidebar-item-icon header" iconName={tech} />
			{/each}
		</div>
	</div>
	<div class="card-desc">{Project.desc}</div>
	<div class="card-actions">
		{#each Project.links as link}
			<a
				class="card-action"
				title={link.tooltip ?? ''}
				href={link.url}
				target="_blank"
				rel="noopener noreferrer"
			>
				<Icon classes="sidebar-item-icon header" iconName={link.icon} />
			</a>
		{/each}
	</div>
</div>

<style lang="scss">
	.card {
		font-size: x-large;
		padding: 2rem;
		background-color: var(--sidebar-primary-color);
		border-radius: 0.5rem;
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		gap: 30px;
		> .card-title {
			font-size: 2rem;
			> .card-badges {
				margin: 1rem 0 0 0;
				display: flex;
				font-size: 1.5rem;
				flex-direction: row;
				gap: 15px;
				border-radius: 0.25rem;
				padding: 0 0.2rem;
			}
		}
		> .card-actions {
			display: flex;
			justify-content: flex-start;
			flex-direction: row-reverse;
			gap: 1rem;
			> .card-action {
				color: var(--accent-text);
				background-color: var(--accent);
				border-radius: 0.25rem;
				padding: 0.5rem 0.5rem;
				line-height: 0;
				transition-duration: 200ms;
				&:hover {
					transition-duration: 200ms;
					background-color: var(--sidebar-background-hover);
					color: var(--sidebar-text-color-hover);
				}
			}
		}
	}
</style>
