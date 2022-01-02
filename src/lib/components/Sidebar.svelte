<script>
	export let currentPage;
	export let routes;
	import { onMount } from 'svelte';
	import { theme, themes } from '../../stores';
	import { fade } from 'svelte/transition';
	import Icon from '$lib/components/Icon.svelte';

	/**
	 * Checks if the theme has contrast
	 * @param {string} themeName The name of the theme
	 * @returns {boolean} Whether the theme has contrast
	 */
	function hasContrast(themeName) {
		return themes.contrast.includes(themeName);
	}

	/**
	 * Checks if the theme is dark
	 * @param {string} themeName The name of the theme
	 * @returns {boolean} Whether the theme is dark
	 */
	function isDark(themeName) {
		return themes.dark.includes(themeName);
	}

	/**
	 * Changes theme by either toggling whether it's dark or has contrast
	 * @param {boolean} toggleTheme Whether it should toggle dark (if false, toggles contrast)
	 * @returns {void}
	 */
	function setTheme(toggleTheme = true) {
		let themeType = isDark($theme) ? 'dark' : 'light';
		let contrastType = hasContrast($theme) ? 0 : 1;

		if (toggleTheme) {
			themeType = themeType === 'dark' ? 'light' : 'dark';
		} else {
			contrastType = contrastType === 1 ? 0 : 1;
		}

		theme.set(themes[themeType][contrastType]);
	}

	/**
	 * Hides the sidebar only if it's on mobile
	 * @returns {void}
	 */
	function safeHideMenu() {
		if (!isMobile) return;
		hideMenu = true;
	}

	/**
	 * [A11Y]: Handles keypress so Space and Enter act as click
	 * @param event Keypress event
	 * @returns {void}
	 */
	function handleKeyEvent(event) {
		if (!event || event.key !== 'Escape') return;
		safeHideMenu();
	}

	// [A11Y]: Focus should be disabled when sidebar is hidden and is not desktop
	let hideMenu = true;
	let isMobile = true;
	onMount(() => {
		if (!matchMedia('(min-width: 768px)')?.matches) return;
		hideMenu = false;
		isMobile = false;
	});

	$: contrastIcon = hasContrast($theme) ? 'circle' : 'adjust';
	$: themeIcon = isDark($theme) ? 'sun' : 'moon';
	$: shouldTab = hideMenu && isMobile ? '-1' : '0';
</script>

<nav on:keydown={(e) => handleKeyEvent(e)}>
	<button
		class="sidebar-menu-button"
		on:click={() => (hideMenu = false)}
		class:hideSideBar={!hideMenu}
		tabIndex={shouldTab === '-1' ? '0' : '-1'}
		aria-label="Open Menu"
	>
		<Icon classes="sidebar-item-icon" iconName="bars" />
	</button>
	<div class="sidebar" class:hideSideBar={hideMenu}>
		<a
			class="sidebar-header"
			data-tooltip="GeopJr"
			sveltekit:prefetch
			href="/"
			tabIndex={shouldTab}
			aria-label="Home"
			on:click={() => safeHideMenu()}
		>
			<img alt="Avatar" src="/images/avi.png" class="avi" />
		</a>
		<div class="sidebar-items" tabIndex="-1">
			{#each Object.entries(routes) as [route, info]}
				<a
					class="sidebar-item"
					data-tooltip={info.title}
					sveltekit:prefetch
					href={route}
					class:active={currentPage === route}
					tabIndex={shouldTab}
					aria-label={info.title}
					on:click={() => safeHideMenu()}
				>
					<Icon classes="sidebar-item-icon" iconName={info.icon} size="24px" />
				</a>
			{/each}
		</div>
		<div class="sidebar-items footer" tabIndex="-1">
			<button
				class="sidebar-item"
				data-tooltip="Contrast Toggle"
				on:click={() => setTheme(false)}
				tabIndex={shouldTab}
				aria-label="Toggle Contrast"
			>
				<Icon classes="sidebar-item-icon" iconName={contrastIcon} size="24px" />
			</button>
			<button
				class="sidebar-item"
				data-tooltip="Theme Toggle"
				on:click={() => setTheme()}
				tabIndex={shouldTab}
				aria-label="Toggle Theme"
			>
				<Icon classes="sidebar-item-icon" iconName={themeIcon} size="24px" />
			</button>
		</div>
	</div>
</nav>
{#if !hideMenu}
	<div
		class="closeArea"
		on:click={() => (hideMenu = true)}
		tabIndex="-1"
		transition:fade={{ duration: 200 }}
	/>
{/if}

<style lang="scss">
	$transition-duration: 200ms;
	$transition-duration-fast: 100ms;
	$sidebar-width-mobile: 80vw;

	nav {
		position: fixed;
		height: 100vh;
		left: 0;
		z-index: 50;
	}

	.closeArea {
		position: fixed;
		right: 0;
		height: 100vh;
		width: 100vw;
		background-color: rgba(0, 0, 0, 0.37);
		z-index: 40;
		@media only screen and (min-width: 768px) {
			display: none;
		}
	}

	.sidebar-menu-button {
		left: 0;
		top: 0;
		border-radius: 0 0 1rem;
		border-right: 4px solid;
		border-bottom: 4px solid;
		border-left: 0;
		border-top: 0;
		border-color: var(--sidebar-text-color);
		position: fixed;
		color: var(--sidebar-text-color);
		background-color: var(--sidebar-primary-color);
		width: 4rem;
		height: 4rem;
		display: flex;
		align-items: center;
		justify-content: center;
		cursor: pointer;
		transition-duration: $transition-duration;
		@media only screen and (min-width: 768px) {
			display: none;
		}
	}

	@media only screen and (max-width: 767px) {
		.hideSideBar {
			left: -$sidebar-width-mobile !important;
			border-width: 0;
			transition-duration: $transition-duration;
			&:focus-visible {
				box-shadow: none;
			}
			&.sidebar-menu-button {
				:global(.sidebar-item-icon) {
					display: none;
					z-index: -50;
				}
			}
		}
	}

	.sidebar {
		transition-duration: $transition-duration;
		z-index: 50;
		display: flex;
		flex-direction: column;
		align-items: center;
		overflow: hidden;
		color: var(--sidebar-text-color);
		background-color: var(--sidebar-primary-color);
		border-bottom-right-radius: 2rem;
		width: $sidebar-width-mobile;
		height: 100vh;
		position: absolute;
		left: 0;
		:global(.sidebar-item-icon) {
			font-size: 2rem;
			margin: 0 15px;
			@media only screen and (min-width: 768px) {
				margin: auto;
			}
		}

		@media only screen and (min-width: 768px) {
			width: 4rem;
			height: 100vh;
			&::before {
				content: '';
				position: fixed;
				background-color: transparent;
				top: -1px;
				left: 4rem;
				height: 50px;
				width: 50px;
				border-top-left-radius: 2rem;
				box-shadow: -25px 0 0 0 var(--sidebar-primary-color);
				z-index: -40;
				transition-duration: $transition-duration;
			}
		}

		[data-tooltip] {
			text-decoration: none;
			word-break: break-all;
			font-weight: bold;
			font-size: 1.4rem;
			&:after {
				position: relative;
				content: attr(data-tooltip);
				text-decoration: none;
				color: var(--sidebar-text-color);
				text-align: left;
				margin: auto;
				display: flex;
				align-items: center;
				padding: 0 1rem;
				z-index: 30;
			}
			@media only screen and (min-width: 768px) {
				&:before {
					position: fixed;
					content: attr(data-tooltip);
					opacity: 0;
					text-decoration: none;
					color: var(--pseudo-text-color);
					border-bottom-right-radius: 2rem;
					left: 4rem;
					height: 3.75rem;
					text-align: left;
					min-width: 10rem;
					margin: auto;
					display: flex;
					align-items: center;
					padding: 0 1rem;
					z-index: 30;
					transition-duration: $transition-duration;
					background: linear-gradient(
						90deg,
						var(--sidebar-secondary-color) 70%,
						var(--sidebar-secondary-alt-color) 30%
					);
				}
				&:hover:before,
				&:focus-visible:before {
					transition-duration: $transition-duration;
					opacity: 1;
				}
				&:not([data-tooltip-persistent]):before {
					pointer-events: none;
				}

				&:after {
					display: none !important;
				}
			}
		}

		> .sidebar-header {
			&[data-tooltip] {
				font-size: 2.5rem;
				&:after {
					margin: auto auto auto 0;
				}
			}
			> .avi {
				width: 1em;
				border-radius: 100%;
				margin: auto 0 auto auto;
				@media only screen and (min-width: 768px) {
					margin: auto;
				}
			}
			display: flex;
			justify-items: center;
			align-items: center;
			margin-top: 0.75rem;
			color: var(--sidebar-text-color);
			align-items: center;
			width: 95%;
			min-height: 3rem;
			margin: 0.5rem;
			text-align: center;
			padding-left: 0.75rem;
			padding-right: 0.75rem;
			border-radius: 0.25rem;
			transition-duration: $transition-duration-fast;
			&:hover,
			&:focus-visible {
				background-color: var(--sidebar-background-hover);
				color: var(--sidebar-text-color-hover);
				transition-duration: $transition-duration-fast;
				&[data-tooltip]:after {
					color: var(--sidebar-text-color-hover);
				}
			}
			@media only screen and (min-width: 768px) {
				width: 3rem;
				padding-left: 0rem;
				padding-right: 0rem;
				border-radius: 100%;
				&:first-child {
					&[data-tooltip]:before {
						z-index: -30;
						height: 4rem;
						background: var(--sidebar-primary-color);
						color: var(--sidebar-text-color);
					}
				}
			}
		}

		> .sidebar-items {
			display: flex;
			align-items: center;
			flex-direction: column;
			width: 100%;
			overflow-y: hidden;
			&:not(&.footer) {
				overflow-y: auto;
				flex-grow: 1;
				flex-basis: 0;
				border-top: 1px solid var(--sidebar-secondary-color);
			}
			&.footer {
				margin-top: auto;
				background-color: var(--sidebar-secondary-color);
				> .sidebar-item {
					color: var(--pseudo-text-color);
					&[data-tooltip]:after {
						color: var(--pseudo-text-color);
					}
					&:last-child {
						border-bottom-right-radius: 2rem;
						@media only screen and (min-width: 768px) {
							border-bottom-left-radius: 0.25rem;
							&[data-tooltip]:before {
								left: 2rem;
								padding: 0 1rem 0 3rem;
								z-index: -10;
							}
						}
					}
				}
			}

			> .sidebar-item {
				display: flex;
				align-items: center;
				color: var(--sidebar-text-color);
				width: 95%;
				min-height: 3rem;
				margin: 0.5rem;
				text-align: center;
				padding-left: 0.75rem;
				padding-right: 0.75rem;
				border-radius: 0.25rem;
				transition-duration: $transition-duration-fast;
				&.active {
					border: 5px solid var(--sidebar-active-color);
					padding-left: 7px;
					padding-right: 7px;
				}
				&:hover,
				&:focus-visible {
					transition-duration: $transition-duration-fast;
					background-color: var(--sidebar-background-hover);
					color: var(--sidebar-text-color-hover);
					&[data-tooltip]:after {
						color: var(--sidebar-text-color-hover);
					}
				}
				@media only screen and (min-width: 768px) {
					width: 3rem;
					padding-left: 0rem;
					padding-right: 0rem;
					&.active {
						padding-left: 0rem;
						padding-right: 0rem;
					}
				}
			}
		}
	}
</style>
