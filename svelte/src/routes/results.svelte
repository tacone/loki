<script>
	import { browser } from '$app/env';
	import Grid from '$lib/Grid.svelte';
	import Result from '$lib/Result.svelte';

	let data = {
		age: [
			{
				value: '51',
				count: 1,
				ratio: 33.333333333333336
			},
			{
				value: '42',
				count: 1,
				ratio: 33.333333333333336
			},
			{
				value: '34',
				count: 1,
				ratio: 33.333333333333336
			}
		],
		country: [
			{
				value: 'italia',
				count: 1,
				ratio: 50
			},
			{
				value: 'Italia',
				count: 1,
				ratio: 50
			}
		],
		gender: [
			{
				value: 'male',
				count: 2,
				ratio: 100
			}
		],
		experience_rating: [
			{
				value: '5',
				count: 2,
				ratio: 100
			}
		],
		total_submissions: 4
	};

	let totalSubmissions = data['total_submissions'];
	let recordsets = { ...data };
	delete recordsets['total_submissions'];
</script>

<main>
	<h2 className="page-title">Risultati ({totalSubmissions} invii)</h2>

	<Grid columns="2" items={recordsets} let:key let:item>
		<Result name={key} records={item} />
	</Grid>
</main>

<style lang="scss">
</style>
