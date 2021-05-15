const c = [
	() => import("../../../src/routes/__layout.svelte"),
	() => import("../../../src/routes/__error.svelte"),
	() => import("../../../src/routes/index.svelte"),
	() => import("../../../src/routes/thank-you.svelte"),
	() => import("../../../src/routes/results.svelte"),
	() => import("../../../src/routes/quiz.svelte")
];

const d = decodeURIComponent;

export const routes = [
	// src/routes/index.svelte
	[/^\/$/, [c[0], c[2]], [c[1]]],

	// src/routes/thank-you.svelte
	[/^\/thank-you\/?$/, [c[0], c[3]], [c[1]]],

	// src/routes/results.svelte
	[/^\/results\/?$/, [c[0], c[4]], [c[1]]],

	// src/routes/quiz.svelte
	[/^\/quiz\/?$/, [c[0], c[5]], [c[1]]]
];

export const fallback = [c[0](), c[1]()];