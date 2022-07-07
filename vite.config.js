import { sveltekit } from '@sveltejs/kit/vite';
import Icons from 'unplugin-icons/vite'
import { FileSystemIconLoader } from 'unplugin-icons/loaders' 

/** @type {import('vite').UserConfig} */
const config = {
    plugins: [
        sveltekit(),
        Icons({
            compiler: 'svelte',
            customCollections: {
                "custom": FileSystemIconLoader("./src/lib/icons")
            }
        })
    ]
};

export default config;