<script>
	import { Sveltik, Form, Field, ErrorMessage } from 'sveltik';

	let initialValues = {
		email: '',
		name: ''
	};

	let validate = (values) => {
		const errors = {};
		if (!values.email) {
			errors.email = 'Required';
		} else if (!/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i.test(values.email)) {
			errors.email = 'Invalid email address';
		}
		return errors;
	};

	let onSubmit = (values, { setSubmitting }) => {
		setTimeout(() => {
			alert(JSON.stringify(values, null, 2));
			setSubmitting(false);
		}, 400);
	};
</script>

<Sveltik {initialValues} {validate} {onSubmit} let:isSubmitting>
	<Form>
		<Field type="text" name="email" />
		<ErrorMessage name="email" as="div" />
		<Field type="name" name="name" />
		<ErrorMessage name="name" as="div" />
		<button type="submit" disabled={isSubmitting}>Submit</button>
	</Form>
</Sveltik>
