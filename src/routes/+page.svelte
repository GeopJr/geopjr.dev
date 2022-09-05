<script>
	import Icon from '$lib/components/Icon.svelte';
	import Egg from '$lib/components/Egg.svelte';
</script>

<div class="title">
	<Egg>
		Hello,
		<Icon classes="wave" iconName="wavinghand" />
		<br />I'm
		<div class="name">Evan</div>
	</Egg>
</div>
<div class="card-container">
	<a data-sveltekit-prefetch class="card" href="/about">
		<div class="card-title">Learn more about me.</div>
		<div class="arrow">
			<Icon iconName="user" />
		</div>
	</a>
	<a data-sveltekit-prefetch class="card" href="/work">
		<div class="card-title">Check out my work.</div>
		<div class="arrow">
			<Icon iconName="briefcase" />
		</div>
	</a>
	<a data-sveltekit-prefetch class="card" href="/blog">
		<div class="card-title">Read my blog.</div>
		<div class="arrow">
			<Icon iconName="book" />
		</div>
	</a>
	<a data-sveltekit-prefetch class="card" href="/contact">
		<div class="card-title">Get in touch.</div>
		<div class="arrow">
			<Icon iconName="address-card" />
		</div>
	</a>
</div>
<div class="tip">Psst... Theme settings!</div>

<style lang="scss">
	$transition-duration: 200ms;

	.tip {
		display: none;
		@media (min-width: 1024px) {
			position: fixed;
			bottom: 2rem;
			left: 5rem;
			width: 1rem;
			pointer-events: none;
			z-index: -10;
			text-align: center;
			display: block;
			opacity: 0;
			animation: delay_show ease-in 1.5s 2s forwards;
			@keyframes delay_show {
				to {
					opacity: 0.5;
				}
			}
		}
	}

	.arrow {
		display: flex;
		flex-direction: row-reverse;
		transition-duration: $transition-duration;
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
	.title {
		font-size: 17vw;
		font-weight: bold;
		@media only screen and (min-width: 768px) {
			font-size: calc(50px + 5vw);
		}
		margin-bottom: 2rem;
	}
	.name {
		background-color: var(--sidebar-secondary-color);
		display: inline-block;
		padding: 0 1rem;
		margin-top: 1rem;
		border-radius: 0.75rem;
		transition-duration: $transition-duration;
		&:hover {
			transition-duration: $transition-duration;
			border-radius: 2rem;
		}
	}
	.card-container {
		display: flex;
		flex-direction: column;
		justify-content: space-around;
		flex-wrap: wrap;
		> .card {
			border: 0.25rem solid transparent;
			transition-duration: $transition-duration;
			&:hover {
				.arrow {
					color: var(--accent);
					transition-duration: $transition-duration;
				}
				border: 0.25rem solid var(--accent);
				transition-duration: $transition-duration;
				> .card-title {
					transition-duration: $transition-duration;
					color: var(--accent);
				}
			}
			font-size: x-large;
			flex-grow: 0;
			flex-basis: 23%;
			padding: 2rem;
			background-color: var(--sidebar-primary-color);
			border-radius: 0.5rem;
			margin: 15px 0;
			display: flex;
			flex-direction: column;
			justify-content: space-between;
			> .card-title {
				transition-duration: $transition-duration;
				font-size: 7vw;
				font-weight: bold;
				@media only screen and (min-width: 768px) {
					font-size: calc(20px + 1vw);
				}
				margin-bottom: 1rem;
			}
			@media (min-width: 1024px) {
				margin: 0;
			}
			@media (min-width: 768px) and (max-width: 1366px) {
				flex-basis: 45%;
				flex-grow: 1;
			}
		}
		@media (min-width: 768px) and (max-width: 1366px) {
			gap: 1rem;
		}
		// Include tablets to mobile
		@media (min-width: 1024px) {
			flex-direction: row;
			margin: 0;
		}
	}

	:global(.wave) {
		animation: wave 2s ease-in-out 0s infinite;
		transform-origin: 70% 70%;
	}

	@keyframes wave {
		20% {
			transform: rotate(-8deg);
		}
		10%, 30% {
			transform: rotate(14deg);
		}
		40% {
			transform: rotate(-4deg);
		}
		50% {
			transform: rotate(10deg);
		}
		0%,
		65%,
		100% {
			transform: rotate(0deg);
		}
	}
</style>
