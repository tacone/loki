<script>
	import Grid from '$lib/Grid.svelte';
	import Result from '$lib/Result.svelte';
	import { request } from 'graphql-request';
	import { browser } from '$app/env';

	const query = `
		query {
			submissionsStatistics {
				age {
					value
					count
					ratio
				}
				experienceRating {
					value
					count
					ratio
				}
				country {
					value
					count
					ratio
				}
				gender {
					value
					count
					ratio
				}
				totalSubmissions
			}
		}`;

	let recordsets = {};
	$: delete recordsets['totalSubmissions'];
	$: totalSubmissions = 0;
	$: promise = !browser
		? true
		: request(import.meta.env.VITE_GRAPHQL_ENDPOINT, query).then((res) => {
				recordsets = res['submissionsStatistics'];
				totalSubmissions = res['submissionsStatistics']['totalSubmissions'];
		  });

	$: console.log(recordsets)
</script>

<main>
	{#await promise}
		<p>...waiting</p>
	{:then number}
		<h2 class="page-title">Risultati ({totalSubmissions} invii)</h2>

		<Grid columns="2" items={recordsets} let:key let:item>
			<Result name={key} records={item} />
		</Grid>
	{:catch error}
		<div class="alert alert-danger text-center" role="alert">Network error</div>
	{/await}
</main>

<style lang="scss">
</style>
