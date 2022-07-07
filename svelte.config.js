import sveltePreprocess from 'svelte-preprocess';
import adapter from '@sveltejs/adapter-cloudflare';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
		adapter: adapter(),
	},
	preprocess: [
		sveltePreprocess({
			scss: true,
			sass: true
		})
	]
};

export default config;
