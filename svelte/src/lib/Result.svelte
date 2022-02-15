<script>
	const humanizeString = (str) => {
		return str.replace(/[A-Z]/g, letter => `_${letter.toLowerCase()}`)
			.replace(/[\-_]/g, ' ')
			.replace(/^\s+/g, '')
			.replace(/\s+$/g, '')
			.replace(/\s+/g, ' ')
			.replace(/(^\w{1})|(\s{1}\w{1})/g, match => match.toUpperCase())
			;
	};

	export let name, records;

	const formatPercent = (value) => (Math.round(value * 100) / 100).toFixed(2);
</script>

<h3>{humanizeString(name)}</h3>
<table class="table results-table table-bordered">
	<thead class="table-dark">
		<tr>
			<th scope="col">{humanizeString(name)}</th>
			<th scope="col" class="numeric-column"> Entries </th>
			<th scope="col" class="numeric-column"> % </th>
		</tr>
	</thead>
	<tbody>
		{#if records && records.length}
			{#each records as r}
				<tr>
					<td>{r.value || '-'}</td>
					<td class="numeric-column">{r.count}</td>
					<td class="numeric-column">{formatPercent(r.ratio)} %</td>
				</tr>
			{/each}
		{:else}
			<tr>
				<td class="text-muted text-center" colSpan="100"> no data yet </td>
			</tr>
		{/if}
	</tbody>
</table>
