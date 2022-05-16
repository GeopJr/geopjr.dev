<script>
	export let text;
	export let visible;
	export let provider;

	import Icon from '$lib/components/Icon.svelte';
	import { scale, fade } from 'svelte/transition';
	import CopyToClipboard from 'svelte-copy-to-clipboard';

	/**
	 * Sets the copy response to success
	 * @returns {void}
	 */
	const handleSuccessfullyCopied = () => {
		response = 'Successfully copied!';
	};

	/**
	 * Sets the copy response to failure
	 * @returns {void}
	 */
	const handleFailedCopy = () => {
		response = 'Failed to copy!';
	};

	/**
	 * [A11Y]: Hides the modal on Esc
	 * @param event Keypress event
	 * @returns {void}
	 */
	function handleKeyEvent(event) {
		if (!event || event.key !== 'Escape') return;
		visible = false;
	}

	let response = '';

	$: response = !visible ? '' : response;
</script>

<svelte:window on:keydown={(e) => handleKeyEvent(e)} />

{#if visible}
	<div class="modal">
		<div class="card" transition:scale={{ duration: 200 }}>
			<div class="title">
				{provider}
			</div>
			<div class="textarea">
				<div class="textbox">
					{text}
				</div>
				<div class="actions">
					<CopyToClipboard
						{text}
						on:copy={handleSuccessfullyCopied}
						on:fail={handleFailedCopy}
						let:copy
					>
						<button tabIndex="0" class="copyBtn" title="Copy" on:click={copy}
							><Icon size="20px" iconName="copy" /></button
						>
					</CopyToClipboard>
					<button tabIndex="0" class="copyBtn" title="Close" on:click={() => (visible = false)}
						><Icon size="20px" iconName="times" /></button
					>
				</div>
			</div>
			<span class="response">{response}</span>
		</div>
		<div class="modalBg" on:click={() => (visible = false)} transition:fade={{ duration: 200 }} />
	</div>
{/if}

<style lang="scss">
	.modalBg {
		position: fixed;
		background-color: rgba(0, 0, 0, 0.666);
		height: 100vh;
		width: 100vw;
		top: 0;
		left: 0;
		z-index: 9;
		transition-duration: 200ms;
	}
	.copyBtn {
		background-color: var(--sidebar-secondary-color);
		padding: 0.5rem;
		border-radius: 0.25rem;
		display: flex;
		flex-direction: row;
		align-items: center;
		color: var(--pseudo-text-color);
	}
	.modal {
		position: fixed;
		height: 100vh;
		width: 100vw;
		top: 0;
		left: 0;
		display: flex;
		justify-content: center;
		align-items: center;
		color: var(--sidebar-text-color);
		padding-left: 0rem;
		z-index: 9;
		@media only screen and (min-width: 768px) {
			padding-left: 4rem;
		}
		> .card {
			max-width: 90vw;
			background-color: var(--sidebar-primary-color);
			padding: 5rem;
			border-radius: 0.75rem;
			display: flex;
			gap: 1.3rem;
			flex-direction: column;
			z-index: 10;
			> .title {
				font-weight: bold;
				text-align: center;
				font-size: 2rem;
				margin-top: -2rem;
			}
			> .response {
				margin-bottom: -2rem;
				text-align: center;
			}
			> .textarea {
				display: flex;
				gap: 1.3rem;
				justify-content: center;
				align-items: center;
				flex-direction: column;
				> .textbox {
					background-color: var(--sidebar-secondary-color);
					color: var(--pseudo-text-color);
					padding: 0.5rem;
					border-radius: 0.25rem;
					font-weight: bold;
					word-wrap: break-word;
					word-break: break-all;
				}
				> .actions {
					display: flex;
					gap: 1rem;
					flex-direction: row;
					color: var(--pseudo-text-color);
				}
				@media only screen and (min-width: 768px) {
					flex-direction: row;
				}
			}
		}
	}
</style>
