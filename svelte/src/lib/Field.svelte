<script>
	import humanizeString from '$utils/strings/humanize-string';

	export let id;
	export let label;
	// export let error;
	export let name = '';

	export let tag = 'input';

	label = label || humanizeString(name);
	id = id || `_survey_${name}`;
</script>

<div class="form-group row">
	<label for={id} class="col-sm-2 col-form-label">
		{label}
	</label>
	<div class="col-sm-10">
		{#if tag === 'input'}
			<h1>
				<input {id} type="text" class="form-control" {...$$props} />
			</h1>
		{:else if tag === 'select'}
			<h2>
				<select {id} class="form-control" {...$$props}><slot /></select>
			</h2>
		{:else if tag === 'textarea'}
			<h3>
				<textarea {id} class="form-control" {...$$props} />
			</h3>
		{/if}
		<div data-felte-reporter-dom-for={name} class="error" />
		<!-- {#if error}
			<small id="emailHelp" class="form-text text-danger">
				{error}
			</small>
		{/if} -->
	</div>
</div>
