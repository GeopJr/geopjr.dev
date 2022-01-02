import sveltePreprocess from 'svelte-preprocess';
import Icons from 'unplugin-icons/vite'
import adapter from '@sveltejs/adapter-cloudflare';
import { FileSystemIconLoader } from 'unplugin-icons/loaders' 

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
		target: '#svelte',
		adapter: adapter(),
		vite: {
			plugins: [
			  Icons({
				compiler: 'svelte',
				customCollections: {
					"custom": FileSystemIconLoader("./src/lib/icons")
				}
			  }),
			],
		  },
	},
	preprocess: [
		sveltePreprocess({
			scss: true,
			sass: true
		})
	]
};

export default config;
