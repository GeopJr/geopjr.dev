<script>
	// This file handles easter eggs on index
	// [IMPORTANT]: These do not ensure that the website will be usable.
	//				It's important to make sure that they are disabled
	//				on mobile and when reduced-motion is enabled.
	import Icon from '$lib/components/Icon.svelte';
	import { eggHint } from '../../stores.js';
	import { onDestroy, onMount } from 'svelte';
	import { browser } from '$app/environment';

	const patterns = ['666', '11037'];
	let input = '';
	let enabled = '';
	/**
	 * Handles the easter eggs
	 * @param e Keypress event
	 * @returns {void}
	 */
	let eggHandler = (e) => {
		if (enabled.length > 0) return;
		const ref = `${input}${e.key}`.toLowerCase();
		if (patterns.filter((x) => x.startsWith(ref)).length === 0) return (input = '');
		input = ref;
		const found = patterns.filter((x) => x === input);
		if (found.length === 0) return;
		input = '';
		enabled = found[0];
		if (browser) {
			window.onkeyup = null;
		}
	};

	/**
	 * Console logs the list of easter eggs
	 * @returns {void}
	 */
	function eggLog() {
		if ($eggHint) return;
		console.log("%cSince you found this, here's the list of easter eggs:", 'font-weight: bold;');
		console.log(patterns);
		eggHint.set(true);
	}

	onMount(() => {
		if (
			matchMedia('(min-width: 768px)')?.matches &&
			!matchMedia('(prefers-reduced-motion: reduce)')?.matches
		)
			return eggLog();
		eggHandler = () => null;
	});

	onDestroy(() => {
		input = '';
		enabled = '';
		if (browser) {
			document?.getElementById('egg-style')?.remove();
			window.onkeyup = null;
		}
	});
</script>

<svelte:window on:keyup={(e) => eggHandler(e)} />

<svelte:head>
	{#if enabled === patterns[0]}
		<style id="egg-style" lang="css">
			:root {
				--text-color: red !important;
				--accent: red !important;
				--accent-text: black !important;
				--background-color: black !important;
				--sidebar-primary-color: #111 !important;
				--sidebar-secondary-color: red !important;
				--sidebar-secondary-alt-color: #222 !important;
				--sidebar-text-color: white !important;
				--sidebar-text-color-hover: black !important;
				--sidebar-background-hover: red !important;
				--sidebar-active-color: red !important;
				--pseudo-text-color: white !important;
			}
			html {
				overflow: hidden;
				background-color: black !important;
			}
			body {
				background-color: black !important;
				overflow: hidden;
				animation-name: tremble;
				animation-duration: 0.5s;
				animation-iteration-count: infinite;
				animation-timing-function: ease-in-out;
			}
			@keyframes tremble {
				0% {
					transform: translate(2px, 1px) rotate(0deg);
				}
				10% {
					transform: translate(-1px, -2px) rotate(-0.1deg);
				}
				20% {
					transform: translate(-3px, 0px) rotate(0.1deg);
				}
				30% {
					transform: translate(0px, 2px) rotate(0deg);
				}
				40% {
					transform: translate(1px, -1px) rotate(0.1deg);
				}
				50% {
					transform: translate(-1px, 2px) rotate(-0.1deg);
				}
				60% {
					transform: translate(-3px, 1px) rotate(0deg);
				}
				70% {
					transform: translate(2px, 1px) rotate(-0.1deg);
				}
				80% {
					transform: translate(-1px, -1px) rotate(0.1deg);
				}
				90% {
					transform: translate(2px, 2px) rotate(0deg);
				}
				100% {
					transform: translate(1px, -2px) rotate(-0.1deg);
				}
			}
		</style>
	{:else if enabled === patterns[1]}
		<style id="egg-style" lang="css">
			:root {
				--text-color: white !important;
				--accent: #eb24c1 !important;
				--accent-text: black !important;
				--background-color: black !important;
				--sidebar-primary-color: #111 !important;
				--sidebar-secondary-color: #eb24c1 !important;
				--sidebar-secondary-alt-color: #222 !important;
				--sidebar-text-color: white !important;
				--sidebar-text-color-hover: black !important;
				--sidebar-background-hover: #eb24c1 !important;
				--sidebar-active-color: #eb24c1 !important;
			}
			body {
				background: url('/images/eggs/danganronpa_lines.svg');
			}
		</style>
	{/if}
</svelte:head>

{#if enabled === patterns[0]}
	<div class="hell">
		<div class="shade tremble text">Baphomet was here</div>
		<Icon classes="egg-hell-icon" size="150vh" iconName="pentagram" />
	</div>
{:else if enabled === patterns[1]}
	<div class="danganronpa">
		<div class="text shade">
			It&#x2019;s not fair...It&#x2019;s not fair not fair not fair notfair notfair notfair
			notfairnotfairnotfairnotfairnotfair...
			<div class="text-2">
				Why won&#x2019;t you forgive me!? If you did something wrong...you&#x2019;d forgive yourself
				right away...!
			</div>
		</div>
		<div class="line" />
		<div class="perspective">
			<img src="/images/eggs/danganronpa.svg" alt="" />
		</div>
	</div>
{:else}
	<slot />
{/if}

<style lang="scss">
	.hell {
		> :global(.egg-hell-icon) {
			transform: rotate(180deg);
			color: red;
			position: fixed;
			z-index: -50;
			top: -10rem;
			right: 0rem;
			display: inline-block;
		}
		> .tremble {
			animation-name: tremble;
			animation-duration: 0.5s;
			animation-iteration-count: infinite;
			animation-timing-function: ease-in-out;
		}
		> .text {
			text-align: center;
		}
	}

	.danganronpa {
		pointer-events: none;
		position: fixed;
		left: -10rem;
		top: 0;
		z-index: -10;
		> .line {
			background: linear-gradient(rgb(255, 255, 255) 50%, #ffffff 50%) no-repeat 50% 75%;
			background-size: 80% 2px;
		}
		> .text {
			margin-left: 5rem;
			z-index: 10;
			position: relative;
			color: #1190cb;
			transform: perspective(100rem) rotateX(-15deg) rotateY(50deg);
			> .text-2 {
				transform: perspective(100rem) rotateX(-20deg) rotateY(-50deg);
				color: yellow;
			}
		}
		> .perspective {
			transform: perspective(100rem) rotateX(-150deg) rotateY(40deg);
			z-index: -50;
			> img {
				max-height: 100vh;
				position: fixed;
				z-index: -50;
				animation-name: rotate;
				animation-duration: 8s;
				animation-iteration-count: infinite;
				animation-timing-function: linear;
				top: -10rem;
				right: 20rem;
				opacity: 0.5;
			}
		}
	}
	.shade {
		text-shadow: -3px -3px 0 #000, 3px -3px 0 #000, -3px 3px 0 #000, 3px 3px 0 #000;
	}

	@keyframes rotate {
		0% {
			transform: rotateZ(0deg);
		}
		100% {
			transform: rotateZ(360deg);
		}
	}
</style>
