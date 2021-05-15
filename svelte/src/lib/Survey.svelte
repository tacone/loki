<script>
	import { goto } from '$app/navigation';
	import { composeValidators, isEmail, isRequired, mapValidators } from '$utils/validators';
	import reporterDom from '@felte/reporter-dom';
	import { createForm } from 'felte';
	import { request } from 'graphql-request';
	import Field from './Field.svelte';

	const mutation = `
		mutation(
			$name: String!
			$email_address: String!
			$age: Int
			$gender: String
			$country: String
			$experience_rating: Int
			$suggested_improvements: String
			$referrer: String
		) {
			createSubmission(
				input: {
					submission: {
						name: $name
						emailAddress: $email_address
						age: $age
						gender: $gender
						country: $country
						experienceRating: $experience_rating
						suggestedImprovements: $suggested_improvements
						referrer: $referrer
					}
				}
			) {
				submission {
					id
				}
			}
		}
	`;

	let formError = '';
	const { form, data, errors, isValid, isSubmitting } = createForm({
		extend: reporterDom({
			single: true
		}),
		onError: (error) => {
			console.error(error);
			formError = 'Could not save';
		},
		validate: mapValidators({
			name: isRequired,
			email_address: composeValidators(isRequired, isEmail)
		}),

		onSubmit: async (values) => {
			formError = '';

			const variables = { ...values, referrer: document.referrer };
			for (let k in variables) {
				let v = variables[k];
				if (v === '') {
					v = null;
				} else {
					if (!isNaN(v)) {
						v = parseInt(v);
					}
				}

				variables[k] = v;
			}

			const endpoint = import.meta.env.VITE_GRAPHQL_ENDPOINT;
			await request(endpoint, mutation, variables);

			goto('/thank-you', true);
		}
	});
	// $: console.log('form', form);
	// $: console.log($data);
	// $: console.log('errors', $errors);
</script>

<form use:form>
	{#if formError}
		<div class="alert alert-danger">{formError}</div>
	{/if}
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

	<input type="submit" value="Sign in" disabled={!$isValid || $isSubmitting} />
</form>

<pre>{JSON.stringify($data, undefined, 2)}</pre>
<pre>{JSON.stringify($errors, undefined, 2)}</pre>
