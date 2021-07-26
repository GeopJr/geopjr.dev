<div class="banner">
	<slot />
</div>

<style lang="scss">
	.banner {
		background-color: var(--sidebar-primary-color);
		font-size: x-large;
		padding: 2rem;
		border-bottom-left-radius: 2rem;
		border-bottom-right-radius: 2rem;
		font-weight: bold;
		margin-top: -4rem;
		margin-bottom: 2rem;
		@media only screen and (min-width: 768px) and (max-height: 910px) {
			margin-top: -1rem;
		}
	}
</style>
