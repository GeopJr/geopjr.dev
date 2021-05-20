<script>
	export let text;
	export let visible;
	export let provider;

	import Icon from '$lib/Icon.svelte';

	import CopyToClipboard from 'svelte-copy-to-clipboard';

	const handleSuccessfullyCopied = () => {
		response = 'Successfully copied!';
	};

	const handleFailedCopy = () => {
		response = 'Failed to copy!';
	};

	let response = '';

	$: response = !visible ? '' : response;

</script>

<div class="modal" class:hidden={!visible}>
	<div class="card" class:hidden={!visible}>
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
					<button tabIndex={visible ? '0' : '-1'} class="copyBtn" title="Copy" on:click={copy}
						><Icon size="20px" iconName="copy" /></button
					>
				</CopyToClipboard>
				<button
					tabIndex={visible ? '0' : '-1'}
					class="copyBtn"
					title="Close"
					on:click={() => (visible = false)}><Icon size="20px" iconName="times" /></button
				>
			</div>
		</div>
		<span class="response">{response}</span>
	</div>
	<div class="modalBg" class:hidden={!visible} on:click={() => (visible = false)} />
</div>

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

		&.hidden {
			transition-duration: 200ms;
			height: 0px;
		}
	}
	.copyBtn {
		background-color: var(--sidebar-secondary-color);
		padding: 0.2rem 0.5rem;
		border-radius: 0.25rem;
		display: flex;
		flex-direction: row;
		align-items: center;
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
		&.hidden {
			// display: none;
			z-index: -100;
		}
		> .card {
			max-width: 90vw;
			background-color: var(--sidebar-primary-color);
			padding: 5rem;
			border-radius: 0.75rem;
			display: flex;
			gap: 22px;
			flex-direction: column;
			z-index: 10;
			&.hidden {
				display: none;
			}
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
				gap: 22px;
				justify-content: center;
				align-items: center;
				flex-direction: column;
				> .textbox {
					background-color: var(--sidebar-secondary-color);
					padding: 0.2rem 1rem;
					border-radius: 0.25rem;
					font-weight: bold;
					word-wrap: break-word;
					word-break: break-all;
				}
				> .actions {
					display: flex;
					gap: 15px;
					flex-direction: row;
				}
				@media only screen and (min-width: 768px) {
					flex-direction: row;
				}
			}
		}
	}

</style>
