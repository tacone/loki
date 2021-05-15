import nodeAdapter from '@sveltejs/adapter-node';
import staticAdapter from '@sveltejs/adapter-static';
import fs from 'fs';
import { dirname, resolve } from 'path';
import sveltePreprocess from 'svelte-preprocess';
import { fileURLToPath } from 'url';


const __dirname = dirname(fileURLToPath(import.meta.url));
let { dependencies } = JSON.parse(fs.readFileSync('./package.json'));

let adapter;

if (process.env.STATIC_WEBSITE) {
	adapter = await staticAdapter({
		pages: 'export'
	});
} else {
	adapter = await nodeAdapter();
}

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
		// By default, `npm run build` will create a standard Node app.
		// You can create optimized builds for different platforms by
		// specifying a different adapter
		adapter: adapter,

		// hydrate the <div id="svelte"> element in src/app.html
		target: '#svelte',

		vite: {
			ssr: {
				noExternal: Object.keys(dependencies || {})
			},
			resolve: {
				alias: {
					$utils: resolve(__dirname, './src/utils')
				}
			}
		}
	},
	// options passed to svelte.preprocess (https://svelte.dev/docs#svelte_preprocess)
	preprocess: sveltePreprocess()
};

export default config;
