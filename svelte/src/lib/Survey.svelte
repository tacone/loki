<script>
	import humanizeString from '../utils/strings/humanize-string';

	// import undot from '$utils/objects/undot';
	// import dot from '$utils/objects/dot';
	// $: data = undot(values);

	import { createForm } from 'svelte-forms-lib';

	let values;

	const { form, state, handleChange, handleSubmit } = createForm({
		onSubmit: (values) => {
			alert(JSON.stringify(values));
		}
	});

	$: console.log(form);
</script>

<form on:submit={handleSubmit}>
	<label for="name">name</label>

	<div class="form-group row">
		<label for="name" class="col-sm-2 col-form-label">{humanizeString('name')}</label>
		<div class="col-sm-10">
			<input id="name" name="name" on:blur={console.log} on:change={handleChange} bind:value={$form.name} />
		</div>
	</div>

	<div class="form-group row">
		<label for="email_address" class="col-sm-2 col-form-label"
			>{humanizeString('email_address')}</label
		>
		<div class="col-sm-10">
			<input
				id="email_address"
				name="email_address"
				on:change={handleChange}
				bind:value={$form.email_address}
			/>
		</div>
	</div>

	<div class="form-group row">
		<label for="age" class="col-sm-2 col-form-label">{humanizeString('age')}</label>
		<div class="col-sm-10">
			<input id="age" name="age" on:change={handleChange} bind:value={$form.age} />
		</div>
	</div>

	<div class="form-group row">
		<label for="gender" class="col-sm-2 col-form-label">{humanizeString('gender')}</label>
		<div class="col-sm-10">
			<input id="gender" name="gender" on:change={handleChange} bind:value={$form.gender} />
		</div>
	</div>

	<div class="form-group row">
		<label for="country" class="col-sm-2 col-form-label">{humanizeString('country')}</label>
		<div class="col-sm-10">
			<input id="country" name="country" on:change={handleChange} bind:value={$form.country} />
		</div>
	</div>

	<div class="form-group row">
		<label for="experience_rating" class="col-sm-2 col-form-label"
			>{humanizeString('experience_rating')}</label
		>
		<div class="col-sm-10">
			<input
				id="experience_rating"
				name="experience_rating"
				on:change={handleChange}
				bind:value={$form.experience_rating}
			/>
		</div>
	</div>

	<div class="form-group row">
		<label for="suggested_improvements" class="col-sm-2 col-form-label"
			>{humanizeString('suggested_improvements')}</label
		>
		<div class="col-sm-10">
			<input
				id="suggested_improvements"
				name="suggested_improvements"
				on:change={handleChange}
				bind:value={$form.suggested_improvements}
			/>
		</div>
	</div>

	<button type="submit">Submit</button>
</form>

<p><strong>data</strong></p>
<pre>
	{JSON.stringify($form, undefined, 4)}
</pre>
<p><strong>state:</strong></p>
<pre>
	{JSON.stringify($form, undefined, 4)}
</pre>

<style lang="scss">
	pre {
		margin-top: 20px;
	}
</style>
