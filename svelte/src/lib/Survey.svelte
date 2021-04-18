<script>
	import { createForm } from 'felte';
	import Field from './Field.svelte';
	import reporterDom from '@felte/reporter-dom';
	import { composeValidators, isEmail, isRequired, mapValidators } from '$utils/validators';

	const { form, data, errors, isValid, isSubmitting } = createForm({
		validate: mapValidators({
			name: isRequired,
			email_address: composeValidators(isRequired, isEmail)
		}),

		extend: reporterDom({
			single: true
		}),

		onSubmit: async (values) => {
			alert(JSON.stringify(values));
			/* call to an api */
		}
	});
	// $: console.log('form', form);
	// $: console.log($data);
	// $: console.log('errors', $errors);
</script>

<form use:form>
	<Field name="name" />
	<Field name="email_address" />
	<Field name="age" />
	<Field name="gender" tag="select">
		<option value="">--- choose ---</option>
		<option value="male">Male</option>
		<option value="female">Female</option>
	</Field>
	<Field name="country" />
	<Field name="experience_rating" tag="select">
		<option value="">--- choose ---</option>
		<option value="5">5 - Great!</option>
		<option value="4">4 - Good</option>
		<option value="3">3 - Average</option>
		<option value="2">2 - Not so good</option>
		<option value="1"> 1 - Let's pretend we don't know each other </option>
	</Field>
	<Field name="suggested_improvements" tag="textarea" />

	<input type="submit" value="Sign in" disabled={!$isValid  || $isSubmitting} />
</form>

<pre>{JSON.stringify($data, undefined, 2)}</pre>
<pre>{JSON.stringify($errors, undefined, 2)}</pre>
