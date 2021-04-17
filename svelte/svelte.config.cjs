const sveltePreprocess = require('svelte-preprocess');
const pkg = require('./package.json');
const { join } = require('path');

let adapter;

if (process.env.STATIC_WEBSITE) {
	// it looks surprisingly difficult to import the adapter
	// from an external file, as Javascript complains about
	// the right way to import a module
	adapter = function ({ out = 'export' } = {}) {
		/** @type {import('@sveltejs/kit').Adapter} */
		const adapter = {
			name: '@sveltejs/adapter-static-custom',

			async adapt(builder) {
				builder.log.minor('Copying assets');
				const static_directory = join(out, 'assets');
				builder.copy_client_files(static_directory);
				builder.copy_static_files(static_directory);

				builder.log.minor('Exporting static pages');
				await builder.prerender({
					force: true,
					dest: `${out}`
				});
			}
		};

		return adapter;
	};
} else {
	adapter = require('@sveltejs/adapter-node');
}

/** @type {import('@sveltejs/kit').Config} */
module.exports = {
	// Consult https://github.com/sveltejs/svelte-preprocess
	// for more information about preprocessors
	preprocess: sveltePreprocess(),
	kit: {
		// By default, `npm run build` will create a standard Node app.
		// You can create optimized builds for different platforms by
		// specifying a different adapter
		adapter: adapter(),

		// hydrate the <div id="svelte"> element in src/app.html
		target: '#svelte',

		vite: {
			ssr: {
				noExternal: Object.keys(pkg.dependencies || {})
			}
		}
	}
};
