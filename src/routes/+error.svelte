<script>
	import { page } from '$app/stores';
	import { theme, themes } from '../stores';

	$: error_raw = `${$page.status} ${$page.error.message}`;
	$: console.error(error_raw);

	$: error = error_raw.length > 30 ? error_raw.substring(0, 33) + '...' : error_raw;
	$: flag = `${themes.dark.includes($theme) ? 'dark' : 'light'}${
		themes.contrast.includes($theme) ? '_contrast' : ''
	}`;
</script>

<div class="error">
	<img src={`/images/error/${flag}.svg`} alt="" class="flag" />
	<h1 class="errorMsg">{error}</h1>
</div>

<style lang="scss">
	.error {
		text-align: center;
	}

	.flag {
		max-height: 200px;
		max-width: 300px;
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
