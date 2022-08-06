<script>
	import Icon from '$lib/components/Icon.svelte';
	import About from '$lib/data/about.json';
</script>

<div class="card-container">
	<div class="col">
		<div class="card">
			<div class="card-title">
				<strong class="accent--block">About Me</strong>
			</div>
			<div class="card-body">
				<p>
					{@html About.about.replace('{arg1}', new Date().getFullYear() - 2017)}
				</p>
			</div>
		</div>

		<div class="card">
			<div class="card-title">
				<strong class="accent--block">What I do</strong>
			</div>
			<div class="card-body">
				<p>
					{@html About.whatido.replace(
						'{arg1}',
						'<a class="about-text-anchor" href="/work" sveltekit:prefetch>Work</a>'
					)}
				</p>
			</div>
		</div>

		<div class="card">
			<div class="card-title">
				<strong class="accent--block">My Interests</strong>
			</div>
			<div class="card-body">
				<p>
					I'm really interested in the following <strong class="accent">topics</strong> and
					<strong class="accent">views</strong>:
					<br />
					{#each About.interests as topic}
						<strong class="accent--block">{topic}</strong>{' '}
					{/each}
				</p>
			</div>
		</div>
	</div>
	<div class="col">
		<div class="card">
			<div class="card-title">
				<strong class="accent--block">My Skills</strong>
			</div>
			<p class="card-subtitle">(Includes only those I really enjoy working with)</p>
			<div class="card-body">
				{#each Object.entries(About.skills) as [category, data]}
					<p><strong class="accent--block">{category}</strong><br /></p>
					<div class="tech">
						{#each Object.entries(data) as [name, sticker]}
							<a
								href={sticker.website}
								target="_blank"
								rel="noopener noreferrer"
								class={`tech-item brand-${name.toLowerCase()}`}
								aria-label={sticker.name}
							>
								<Icon size="80px" classes="about-icon" iconName={name} />
								<strong class="accent--block subtitle">{sticker.name}</strong>
							</a>
						{/each}
					</div>
				{/each}
			</div>
		</div>
	</div>
</div>

<style lang="scss">
	@use 'sass:list';
	@import '../lib/styles/technologies.scss';

	.card-container {
		@media (min-width: 1024px) {
			column-count: 2;
			column-gap: 2rem;
			display: flex;
		}
		> .col {
			flex-direction: column;
			gap: 2rem;
			display: inline-flex;
			break-inside: avoid-column;
			width: 100%;
			height: 100%;
			&:not(:first-child) {
				margin-top: 2rem;
				@media (min-width: 1024px) {
					margin-top: 0;
				}
			}
			.card {
				display: flex;
				justify-content: start;
				flex-grow: 1;
			}
		}
	}

	$transition-duration: 200ms;

	@each $color-name, $color-list in $colors-tech {
		.brand-#{$color-name} {
			> .subtitle {
				background-color: list.nth($color-list, 1);
				color: list.nth($color-list, 2);
			}

			&:hover,
			&:focus-visible {
				color: list.nth($color-list, 1) !important;
			}
		}
	}
	a,
	a:link,
	a:visited,
	a:hover,
	a:active {
		color: inherit;
		text-decoration: inherit;
		font-weight: inherit;
	}
	.tech {
		display: flex;
		gap: 1rem;
		flex-wrap: wrap;
		margin-top: 1rem;
		justify-content: center;
		> .tech-item {
			filter: drop-shadow(0 0 0.2rem transparent);
			position: relative;
			transition-duration: $transition-duration;
			display: flex;
			flex-direction: column;
			justify-content: space-between;
			align-items: center;
			z-index: 0;
			&:hover,
			&:focus-visible {
				filter: drop-shadow(0 0 0.2rem var(--accent));
				transition-duration: $transition-duration;
				z-index: 10;
				> .subtitle {
					opacity: 1;
					transition-duration: $transition-duration;
				}
			}
			> .subtitle {
				text-align: center;
				opacity: 0;
				transition-duration: $transition-duration;
				position: absolute;
				top: 100%;
				margin: auto;
				pointer-events: none;
			}
		}
	}

	:global(.about-icon) {
		min-width: 100px;
		margin: 0 0 1rem 0;
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
		&:hover {
			border: 0.25rem solid var(--accent);
			transition-duration: $transition-duration;
		}
		> .card-title {
			font-size: 2rem;
			display: flex;
			justify-content: space-between;
			flex-direction: row;
			word-break: break-word;
		}
	}
	:global(.about-text-anchor) {
		text-decoration: underline !important;
	}
</style>
