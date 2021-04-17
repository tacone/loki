<script>
	import humanizeString from '$utils/strings/humanize-string';

	export let id;
	export let label;
	export let touched;
	export let error;
	export let name = '';

	label = label || humanizeString(name);
	id = `_survey_${name}`;
</script>

<div class="form-group row">
	<label for={id} class="col-sm-2 col-form-label">
		{label}
	</label>
	<div class="col-sm-10">
		<slot />
		{#if touched && error}
			<small id="emailHelp" class="form-text text-danger">
				{error}
			</small>
		{/if}
	</div>
</div>
