<script>
	import { getValues } from './actions/form/getValues.js';
	import { useActions } from './actions/actions.js';
	import { enforceSchema, serialize } from './utils/serialize.js';
	export let values = undefined;

	let form;

	$: {
		if (form) {
			const newValues = enforceSchema(form, values);
			if (newValues) {
				values = newValues;
			}
		}
	}

	export let actions = [];
</script>

<form
	on:update={({ detail, target }) => (values = { ...serialize(target), ...detail })}
	bind:this={form}
	use:getValues={values}
	use:useActions={actions}
	on:submit
>
	<slot />
</form>
