const staticRender = true

import sveltePreprocess from 'svelte-preprocess';
import adapterCF from '@sveltejs/adapter-cloudflare';
import adapterStatic from '@sveltejs/adapter-static';

const adapter = staticRender ? adapterStatic : adapterCF;
const adapterOptions = staticRender ? { fallback: "404.html" } : {}
// const prod = process.env.NODE_ENV === "production";

import { mdsvex } from 'mdsvex';
import remarkOembed from 'remark-oembed';
import rehypeExternalLinks from 'rehype-external-links'
import { rehypeAccessibleEmojis } from 'rehype-accessible-emojis'
import rehypeUrls from "rehype-urls"

const blogExtensions = ['.md']

function rehypeUrlRemoveBase(url) {
	if (url.host === 'geopjr.dev') {
		return url.path
	}
}

/** @type {import('@sveltejs/kit').Config} */
const config = {
	extensions: [
		'.svelte',
		...blogExtensions
	],
	kit: {
		adapter: adapter(adapterOptions),
	},
	preprocess: [
		sveltePreprocess({
			scss: true,
			sass: true
		}),
		mdsvex({
			extensions: blogExtensions,
			remarkPlugins: [[remarkOembed, { syncWidget: true }]],
			rehypePlugins: [
				[rehypeExternalLinks, { target: '_blank', rel: ['noopener', 'noreferrer'] }],
				rehypeAccessibleEmojis,
				[rehypeUrls, rehypeUrlRemoveBase]
			],
			layout: {
				_: "./src/lib/layouts/blog_post.svelte",
			}
		})
	]
};

if (staticRender) {
	config.kit.prerender = {
		default: true
	}
}

export default config;
