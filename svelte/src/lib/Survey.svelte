<script>
	import Form from '../svelte-forms/index';
	import undot from '$utils/objects/undot';
	import Field from './Field.svelte';
	import dot from '$utils/objects/dot';

	let values;

	// we can use undot to support dot notation in fieldnames
	// and have nested data
	$: data = undot(values);
</script>

<div>
	<Form bind:values>
		<Field name="name.first" touched="true" error="vietato!">
			<input type="text" name="name.first" class="form-control" />
		</Field>

		<div>
			<button
				type="button"
				on:click={() => {
					values = { ciaone: 'reset' };
				}}>reset</button
			>

			<button
				type="button"
				on:click={() => {
					console.log('values', values);
				}}>go</button
			>
		</div>
	</Form>

	<pre>
		{JSON.stringify(data, undefined, 4)}
	</pre>

	<pre>
		{JSON.stringify(dot(data), undefined, 4)}
	</pre>
</div>

<style lang="scss" ✂prettier:content>
	pre {
		margin-top: 20px;
	}
</style>
