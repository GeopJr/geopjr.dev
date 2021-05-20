<script>
	export let currentPage;
	export let routes;
	import { onMount } from 'svelte';
	import { theme, themes } from '../../stores';

	import Icon from '$lib/Icon.svelte';

	const routesPlus = {};
	const colors = ['red', 'orange', 'yellow', 'green'];
	const icons = ['briefcase', 'dev', 'donate', 'address-card'];

	Object.entries(routes).forEach(([k, v], i) => {
		if (k === '/') return;
		routesPlus[k] = {
			title: v,
			color: colors[i - 1],
			icon: icons[i - 1]
		};
	});

	function hasContrast(themeName) {
		return themes.contrast.includes(themeName);
	}

	function isDark(themeName) {
		return themes.dark.includes(themeName);
	}

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

	// [A11Y]: Space and Enter should act as click
	function handleKeyEvent(event, set = false) {
		if (event && event.key !== 'Enter' && event.key !== ' ') return;
		hideMenu = set;
	}

	// [A11Y]: Focus should be disabled when sidebar is hidden and is not desktop
	let hideMenu = true;
	onMount(() => {
		if (!matchMedia('(min-width: 768px)')?.matches) return;
		hideMenu = false;
	});

	$: contrastIcon = hasContrast($theme) ? 'circle' : 'adjust';
	$: themeIcon = isDark($theme) ? 'sun' : 'moon';
	$: shouldUseRainbow = $theme === themes.dark[1] ? true : false;
	$: shouldTab = hideMenu ? '-1' : '0';

</script>

<nav>
	<buton
		class="sidebar-menu-button open"
		on:click={() => (hideMenu = false)}
		class:hideSideBar={!hideMenu}
		tabIndex={shouldTab === '-1' ? '0' : '-1'}
		on:keydown={(e) => handleKeyEvent(e)}
		aria-label="Open Menu"
	>
		<Icon classes="sidebar-item-icon" iconName="bars" />
	</buton>
	<div class="sidebar" class:hideSideBar={hideMenu}>
		<a
			class="sidebar-header"
			data-tooltip="GeopJr"
			sveltekit:prefetch
			href="/"
			tabIndex={shouldTab}
			aria-label="Home"
			on:click={() => (hideMenu = true)}
		>
			<img alt="Avatar" src="/images/avi.png" class="avi" />
		</a>
		<div class="sidebar-items">
			{#each Object.entries(routesPlus) as [route, info]}
				<a
					class={'sidebar-item' + (shouldUseRainbow ? ' glass-' + info.color : '')}
					data-tooltip={info.title}
					sveltekit:prefetch
					href={route}
					class:active={currentPage === route}
					tabIndex={shouldTab}
					aria-label={info.title}
					on:click={() => (hideMenu = true)}
				>
					<Icon classes="sidebar-item-icon" iconName={info.icon} />
				</a>
			{/each}
		</div>
		<div class="sidebar-items footer">
			<button
				class="sidebar-item"
				class:glass-blue={shouldUseRainbow}
				data-tooltip="Contrast Toggle"
				on:click={() => setTheme(false)}
				tabIndex={shouldTab}
				aria-label="Toggle Contrast"
			>
				<Icon classes="sidebar-item-icon" iconName={contrastIcon} />
			</button>
			<button
				class="sidebar-item"
				class:glass-purple={shouldUseRainbow}
				data-tooltip="Theme Toggle"
				on:click={() => setTheme()}
				tabIndex={shouldTab}
				aria-label="Toggle Theme"
			>
				<Icon classes="sidebar-item-icon" iconName={themeIcon} />
			</button>
		</div>
		<div class:hideSideBar={hideMenu} class="closeArea" on:click={() => (hideMenu = true)} />
		<buton
			class="sidebar-menu-button"
			on:click={() => (hideMenu = true)}
			class:hideSideBar={hideMenu}
			tabIndex={shouldTab}
			on:keydown={(e) => handleKeyEvent(e, true)}
			aria-label="Close Menu"
		>
			<Icon classes="sidebar-item-icon" iconName="times" />
		</buton>
	</div>
</nav>

<style lang="scss">
	$transition-duration: 200ms;
	$transition-duration-fast: 100ms;

	.sidebar-menu-button {
		&.open {
			left: 0;
			top: 0;
			bottom: initial;
			border-radius: 0 0 1rem;
			border-right: 4px solid;
			border-bottom: 4px solid;
			border-left: 0;
			border-top: 0;
		}
		border: 4px solid;
		border-color: var(--sidebar-text-color);
		position: fixed;
		color: var(--sidebar-text-color);
		bottom: 15px;
		background-color: var(--sidebar-primary-color);
		border-radius: 100%;
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
			height: 0 !important;
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
			&.closeArea {
				// display: none !important;
				height: 0;
				transition-duration: $transition-duration;
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
		border-bottom-left-radius: 2rem;
		width: 100%;
		height: 80vh;
		position: absolute;
		:global(.sidebar-item-icon) {
			font-size: 2rem;
			margin: 0 15px;
			@media only screen and (min-width: 768px) {
				margin: auto;
			}
		}

		.closeArea {
			position: fixed;
			bottom: 0px;
			height: 25vh;
			width: 100vw;
			background-color: rgba(0, 0, 0, 0.37);
			transition-duration: $transition-duration;
			z-index: -10;
			@media only screen and (min-width: 768px) {
				display: none;
			}
		}

		@media only screen and (min-width: 768px) {
			width: 4rem;
			height: 100vh;
			border-bottom-left-radius: 0rem;
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

		@media only screen and (min-width: 768px) {
			[data-tooltip]:before {
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
			[data-tooltip]:hover:before,
			[data-tooltip]:focus-visible:before {
				transition-duration: $transition-duration;
				opacity: 1;
			}
			[data-tooltip]:not([data-tooltip-persistent]):before {
				pointer-events: none;
			}

			[data-tooltip]:after {
				display: none !important;
			}
		}

		[data-tooltip]:after {
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

		[data-tooltip] {
			text-decoration: none;
			word-break: break-all;
			font-weight: bold;
			font-size: 1.4rem;
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
			height: 3rem;
			align-items: center;
			width: 95vw;
			height: 3rem;
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
			border-top: 1px solid var(--sidebar-secondary-color);
			width: 100%;
			&.footer {
				margin-top: auto;
				background-color: var(--sidebar-secondary-color);
				border-top: none;
				> .sidebar-item {
					color: var(--pseudo-text-color);
					&[data-tooltip]:after {
						color: var(--pseudo-text-color);
					}
					&:last-child {
						border-bottom-right-radius: 1rem;
						border-bottom-left-radius: 1rem;
						@media only screen and (min-width: 768px) {
							border-bottom-right-radius: 2rem;
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
				width: 90vw;
				height: 3rem;
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
