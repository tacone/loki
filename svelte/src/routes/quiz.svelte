<script>
	// import { browser } from '$app/env';
	import { browser } from '$app/env';
	import Survey from '$lib/Survey.svelte';

	// import { request } from 'graphql-request';

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
</script>

<main>
	<p>Completa questo breve questionario per darci la tua impressione.</p>
	<p>
		<span class="text-muted">
			(<strong>ps: </strong>quis fugiat officia nisi aute et. Irure reprehenderit proident fugiat
			labore sint voluptate voluptate enim ad aliquip do elit. Nulla ad ex eiusmod ipsum consequat
			incididunt do non eu officia fugiat cillum nulla tempor.)
		</span>
	</p>

		<Survey />
</main>

<style lang="scss">
</style>
