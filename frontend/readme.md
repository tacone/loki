# Frontend service

This is a sample frontend service featuring:

- NodeJs
- NextJs
- Preact
- Apollo Client (GraphQl)
- Final Form
- Bootstrap 4 (SCSS)
- Nginx *(production only)*
- `@fontsource/open-sans`

In production mode the docker images will pre-compress the static assets using [brotli]. A Nginx instance will be started to directly serve the static files and transparently proxy the remaining requests to the Node/NextJs server.

If `features/static-next` is included in the start script (`dev`/`production`) the website will be exported and compressed as a totally static site, the NodeJs container will be stopped after publishing the files and Nginx will serve everything.

The static feature also include far expire headings for every filename that includes an hash. This is for letting external proxies to cache the file preventing the browser request to even hitting your Nginx. It is a bit extreme, so if you don't like it feel free to remove it.

[brotli]: https://github.com/google/brotli

## NextJS

This is your friendly neighborhood NextJs, configured to use Preact.

## Nginx

Nginx is set up with HTTP/2 support and gzip and brotli compression. Default self-signed certificates are provided, feel free to to replace them with your own.

## CSS

You may want to tweak bootstrap.scss to include or comment what you need to render you website.

By default I use OpenSans as my font of choice, if you don't like it just remove the according lines from the scss files and from `package.json`. Or use it as an example for how to include a custom webfont (without CDN obscenities).
