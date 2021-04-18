<script>
	export let status;
	export let error;

	import '../app.scss';

	const message= error?.message ?? 'Unknown error'

</script>

<h1>{status || 'Error'}</h1>
<p>{message}</p>

