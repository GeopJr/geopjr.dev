<script>
	import Data from '$lib/data/index.json';

	import Icon from '$lib/Icon.svelte';
</script>

<div class="title">
	Hello,
	<Icon iconName="wavinghand" />
	<br />I'm
	<div class="name">Evan</div>
</div>
<div class="card-container">
	<div class="card">
		Nice to meet you! I go by <strong class="accent">GeopJr</strong> 🧙 online, but feel free to
		call me <strong class="accent">Evan</strong> or <strong class="accent">Geop</strong>. I am a
		<strong class="accent">University Student</strong> 🧑‍🎓 from
		<strong class="accent">Greece</strong> 🇬🇷 and a programmer 🧑‍💻 for about
		<strong class="accent">{new Date().getFullYear() - 2015}</strong>
		years, mostly as a <strong class="accent">freelance full-stack web dev</strong>! 🌐
	</div>
	<div class="card">
		I mainly enjoy writing in and using the following <strong class="accent">languages</strong> and
		<strong class="accent">technologies</strong>:
		{#each Data.techs as technology}
			<strong class="accent--block">{technology}</strong>{' '}
		{/each}
	</div>
	<div class="card">
		I'm really interested in the following <strong class="accent">topics</strong> and
		<strong class="accent">views</strong>:
		{#each Data.interests as topic}
			<strong class="accent--block">{topic}</strong>{' '}
		{/each}
	</div>
</div>

<style lang="scss">
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
		transition-duration: 300ms;
		&:hover {
			transition-duration: 300ms;
			border-radius: 2rem;
		}
	}
	.card-container {
		display: flex;
		flex-direction: column;
		justify-content: space-around;
		flex-wrap: wrap;
		> .card {
			font-size: x-large;
			flex-grow: 0;
			flex-basis: 30%;
			padding: 2rem;
			background-color: var(--sidebar-primary-color);
			border-radius: 0.5rem;
			margin: 15px 0;
			@media (min-width: 1024px) {
				margin: 0;
			}
			@media (min-width: 768px) and (max-width: 1366px) {
				flex-basis: 45%;
				flex-grow: 1;
			}
		}
		@media (min-width: 768px) and (max-width: 1366px) {
			gap: 15px;
		}
		// Include tablets to mobile
		@media (min-width: 1024px) {
			flex-direction: row;
			margin: 0;
		}
	}
</style>
