<script>
	import Grid from '$lib/Grid.svelte';
	import Result from '$lib/Result.svelte';
	import { request } from 'graphql-request';
	import { browser } from '$app/env';

	import { initClient, query, operationStore } from '@urql/svelte';

	initClient({
		url: import.meta.env.VITE_GRAPHQL_ENDPOINT,
		maskTypename: true
	});

	const store = operationStore(`
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
		}`);

	let recordsets = {};
	let totalSubmissions = 0;

	if (browser) query(store);

	$: {
		let data = $store.data;
		recordsets = data?.submissionsStatistics || {};
		totalSubmissions = data?.submissionsStatistics?.totalSubmissions || 0;
		delete recordsets['totalSubmissions'];
	}

	// $: promise = !browser
	// 	? true
	// 	: request(import.meta.env.VITE_GRAPHQL_ENDPOINT, query).then((res) => {
	// 			recordsets = res['submissionsStatistics'];
	// 			totalSubmissions = res['submissionsStatistics']['totalSubmissions'];
	// 	  });

	// $: promise = !browser
	// 	? true
	// 	: request(import.meta.env.VITE_GRAPHQL_ENDPOINT, query).then((res) => {
	// 			recordsets = res['submissionsStatistics'];
	// 			totalSubmissions = res['submissionsStatistics']['totalSubmissions'];
	// 	  });

	$: console.log('recordsets', recordsets);
	$: console.log('store', store);
</script>

<main>
	{#if $store.fetching}
		<p>...waiting</p>
	{:else if $store.error}
		<div class="alert alert-danger text-center" role="alert">Network error</div>
	{:else}
		<h2 class="page-title">Risultati ({totalSubmissions || 0} invii)</h2>

		<Grid columns="2" items={recordsets} let:key let:item>
			<Result name={key} records={item} />
		</Grid>
	{/if}

	<!-- {#await promise}
		<p>...waiting</p>
	{:then number}
		<h2 class="page-title">Risultati ({totalSubmissions} invii)</h2>

		<Grid columns="2" items={recordsets} let:key let:item>
			<Result name={key} records={item} />
		</Grid>
	{:catch error}
		<div class="alert alert-danger text-center" role="alert">Network error</div>
	{/await} -->
</main>

<style lang="scss">
</style>
