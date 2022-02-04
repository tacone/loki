<script>
	import '../custom.scss';
	import '../app.scss';
</script>

<svelte:head>
	<title>Svelte Survey</title>
	<link rel="icon" href="/favicon.ico" />
</svelte:head>

<div class="container container-md">
	<h1 class="header">
		<a href="/">
			<img class="logo" src="/images/logo.svg" style="width:300px" alt="" />
		</a>
		The survey
	</h1>

	<slot />
</div>
