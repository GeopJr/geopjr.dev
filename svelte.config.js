import sveltePreprocess from 'svelte-preprocess';
import adapter from '@sveltejs/adapter-netlify';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
		target: '#svelte',
		adapter: adapter()
	},
	preprocess: [
		sveltePreprocess({
			scss: true,
			sass: true
		})
	]
};

export default config;
