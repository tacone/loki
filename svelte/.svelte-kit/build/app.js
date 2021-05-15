import { respond } from '@sveltejs/kit/ssr';
import root from './generated/root.svelte';
import { set_paths } from './runtime/paths.js';
import { set_prerendering } from './runtime/env.js';
import * as user_hooks from "./hooks.js";

const template = ({ head, body }) => "<!DOCTYPE html>\n<html lang=\"en\">\n\t<head>\n\t\t<meta charset=\"utf-8\" />\n\t\t<link rel=\"icon\" href=\"/favicon.ico\" />\n\t\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />\n\t\t" + head + "\n\t</head>\n\t<body>\n\t\t<div id=\"svelte\">" + body + "</div>\n\t</body>\n</html>\n";

let options = null;

// allow paths to be overridden in svelte-kit preview
// and in prerendering
export function init(settings) {
	set_paths(settings.paths);
	set_prerendering(settings.prerendering || false);

	options = {
		amp: false,
		dev: false,
		entry: {
			file: "/./_app/start-a3e063df.js",
			css: ["/./_app/assets/start-a8cd1609.css"],
			js: ["/./_app/start-a3e063df.js","/./_app/chunks/vendor-8a4ca113.js","/./_app/chunks/singletons-bb9012b7.js"]
		},
		fetched: undefined,
		floc: false,
		get_component_path: id => "/./_app/" + entry_lookup[id],
		get_stack: error => String(error), // for security
		handle_error: error => {
			console.error(error.stack);
			error.stack = options.get_stack(error);
		},
		hooks: get_hooks(user_hooks),
		hydrate: true,
		initiator: undefined,
		load_component,
		manifest,
		paths: settings.paths,
		read: settings.read,
		root,
		router: true,
		ssr: true,
		target: "#svelte",
		template,
		trailing_slash: "never"
	};
}

const d = decodeURIComponent;
const empty = () => ({});

const manifest = {
	assets: [{"file":"favicon.ico","size":1150,"type":"image/vnd.microsoft.icon"},{"file":"images/logo.svg","size":6123,"type":"image/svg+xml"},{"file":"robots.txt","size":67,"type":"text/plain"}],
	layout: "src/routes/__layout.svelte",
	error: "src/routes/__error.svelte",
	routes: [
		{
						type: 'page',
						pattern: /^\/$/,
						params: empty,
						a: ["src/routes/__layout.svelte", "src/routes/index.svelte"],
						b: ["src/routes/__error.svelte"]
					},
		{
						type: 'page',
						pattern: /^\/thank-you\/?$/,
						params: empty,
						a: ["src/routes/__layout.svelte", "src/routes/thank-you.svelte"],
						b: ["src/routes/__error.svelte"]
					},
		{
						type: 'page',
						pattern: /^\/results\/?$/,
						params: empty,
						a: ["src/routes/__layout.svelte", "src/routes/results.svelte"],
						b: ["src/routes/__error.svelte"]
					},
		{
						type: 'page',
						pattern: /^\/quiz\/?$/,
						params: empty,
						a: ["src/routes/__layout.svelte", "src/routes/quiz.svelte"],
						b: ["src/routes/__error.svelte"]
					}
	]
};

// this looks redundant, but the indirection allows us to access
// named imports without triggering Rollup's missing import detection
const get_hooks = hooks => ({
	getSession: hooks.getSession || (() => ({})),
	handle: hooks.handle || (({ request, render }) => render(request))
});

const module_lookup = {
	"src/routes/__layout.svelte": () => import("../../src/routes/__layout.svelte"),"src/routes/__error.svelte": () => import("../../src/routes/__error.svelte"),"src/routes/index.svelte": () => import("../../src/routes/index.svelte"),"src/routes/thank-you.svelte": () => import("../../src/routes/thank-you.svelte"),"src/routes/results.svelte": () => import("../../src/routes/results.svelte"),"src/routes/quiz.svelte": () => import("../../src/routes/quiz.svelte")
};

const metadata_lookup = {"src/routes/__layout.svelte":{"entry":"/./_app/pages/__layout.svelte-f8e25fb9.js","css":["/./_app/assets/app-2214e3d9.css"],"js":["/./_app/pages/__layout.svelte-f8e25fb9.js","/./_app/chunks/vendor-8a4ca113.js"],"styles":null},"src/routes/__error.svelte":{"entry":"/./_app/pages/__error.svelte-fd654403.js","css":["/./_app/assets/app-2214e3d9.css"],"js":["/./_app/pages/__error.svelte-fd654403.js","/./_app/chunks/vendor-8a4ca113.js"],"styles":null},"src/routes/index.svelte":{"entry":"/./_app/pages/index.svelte-6aa140a6.js","css":[],"js":["/./_app/pages/index.svelte-6aa140a6.js","/./_app/chunks/vendor-8a4ca113.js"],"styles":null},"src/routes/thank-you.svelte":{"entry":"/./_app/pages/thank-you.svelte-9234a991.js","css":[],"js":["/./_app/pages/thank-you.svelte-9234a991.js","/./_app/chunks/vendor-8a4ca113.js"],"styles":null},"src/routes/results.svelte":{"entry":"/./_app/pages/results.svelte-040f0a59.js","css":[],"js":["/./_app/pages/results.svelte-040f0a59.js","/./_app/chunks/vendor-8a4ca113.js"],"styles":null},"src/routes/quiz.svelte":{"entry":"/./_app/pages/quiz.svelte-9bedb9f6.js","css":[],"js":["/./_app/pages/quiz.svelte-9bedb9f6.js","/./_app/chunks/vendor-8a4ca113.js","/./_app/chunks/singletons-bb9012b7.js"],"styles":null}};

async function load_component(file) {
	return {
		module: await module_lookup[file](),
		...metadata_lookup[file]
	};
}

init({ paths: {"base":"","assets":"/."} });

export function render(request, {
	prerender
} = {}) {
	const host = request.headers["host"];
	return respond({ ...request, host }, options, { prerender });
}