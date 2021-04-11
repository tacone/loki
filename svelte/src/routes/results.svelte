<script>
	import Grid from '$lib/Grid.svelte';
	import Result from '$lib/Result.svelte';
	import { request } from 'graphql-request';
	import { browser } from '$app/env';

	const query = `
		query {
			submission_statistics {
				age {
					value
					count
					ratio
				}
				experience_rating {
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
				total_submissions
			}
		}`;

	let recordsets = {};
	$: delete recordsets['total_submissions'];
	$: totalSubmissions = 0;
	$: promise = !browser
		? true
		: request(import.meta.env.VITE_GRAPHQL_ENDPOINT, query).then((res) => {
				recordsets = res['submission_statistics'];
				totalSubmissions = res['submission_statistics']['total_submissions'];
		  });
</script>

<main>
	{#await promise}
		<p>...waiting</p>
	{:then number}
		<h2 className="page-title">Risultati ({totalSubmissions} invii)</h2>

		<Grid columns="2" items={recordsets} let:key let:item>
			<Result name={key} records={item} />
		</Grid>
	{:catch error}
		<div class="alert alert-danger text-center" role="alert">Network error</div>
	{/await}
</main>

<style lang="scss">
</style>
