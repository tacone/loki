<script>
	function chunk(array, size) {
		const arrayChunks = [];
		let arrayCopy = [...array];
		const chunksCount = Math.ceil(arrayCopy.length / size); // Round up to the nearest integer
		for (let i = 0; i < chunksCount; i++) {
			arrayChunks.push(arrayCopy.splice(0, size));
		}
		return arrayChunks;
	}

	export let items;
	export let columns;
	const rows = chunk(Object.keys(items), columns);
</script>

<div>
	{#each rows as r}
		<div class="row">
			{#each r as name}
				<div class="col">
					<slot key={name} item={items[name]} />
				</div>
			{/each}
		</div>
	{/each}
</div>

<style lang="scss">
</style>
