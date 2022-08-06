<script>
	export let Project;
	export let showDate = false;
	export let icons = false;

	import Icon from '$lib/components/Icon.svelte';
</script>

<div class="card">
	<div class="card-title">
		<div class="name">
			<strong class="accent--block">{Project.name}</strong>
			<div class="card-badges">
				{#each Project.techs as tech}
					<Icon size="25px" iconName={tech} />
				{/each}
			</div>
		</div>
		{#if icons}
			{#if Project.icon}
				<Icon size="80px" classes="sticker" iconName={Project.icon} />
			{:else if Project.image}
				<img
					src={Project.image}
					alt={'Icon for ' + Project.name}
					class="sticker"
					style="max-width:100px;max-height:100px;"
				/>
			{/if}
		{/if}
	</div>
	{#if Project.desc}
		<div class="card-desc">{Project.desc}</div>
	{/if}
	{#if showDate}
		<div class="card-date">{Project.date}</div>
	{/if}
	<div class="card-actions">
		{#each Project.links as link}
			<a
				class="card-action"
				title={link.tooltip ?? ''}
				href={link.url}
				target={link.url.startsWith('/') ? null : '_blank'}
				sveltekit:prefetch
				rel="noopener noreferrer"
				aria-label={link.tooltip ?? null}
			>
				<Icon size="25px" iconName={link.icon} />
			</a>
		{/each}
	</div>
</div>

<style lang="scss">
	$transition-duration: 200ms;

	:global(.sticker) {
		min-width: 100px;
		margin: 0 0 1rem 0;
		@media only screen and (min-width: 1400px),
			only screen and (min-width: 511px) and (max-width: 767px) {
			margin: 0 0 0 1rem;
		}
		filter: drop-shadow(0 0 0.2rem var(--accent));
	}
	.card {
		font-size: x-large;
		padding: 2rem;
		background-color: var(--sidebar-primary-color);
		border-radius: 0.5rem;
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		gap: 1rem;
		border: 0.25rem solid transparent;
		transition-duration: $transition-duration;
		position: relative;
		&:hover {
			border: 0.25rem solid var(--accent);
			transition-duration: $transition-duration;
		}
		> .card-title {
			font-size: 2rem;
			display: flex;
			justify-content: space-between;
			@media only screen and (min-width: 1400px),
				only screen and (min-width: 511px) and (max-width: 767px) {
				flex-direction: row;
			}
			// flex-wrap: wrap-reverse;
			flex-direction: column-reverse;
			> .name {
				word-break: break-word;
				> .card-badges {
					margin: 1rem 0 0 0;
					display: flex;
					font-size: 1.5rem;
					flex-direction: row;
					gap: 1rem;
					border-radius: 0.25rem;
					padding: 0 0.2rem;
					flex-wrap: wrap;
				}
			}
		}
		> .card-date {
			font-size: small;
			position: absolute;
			bottom: 2rem;
			font-weight: bold;
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
				transition-duration: $transition-duration;
				&:hover {
					transition-duration: $transition-duration;
					background-color: var(--sidebar-background-hover);
					color: var(--sidebar-text-color-hover);
				}
			}
		}
	}
</style>
