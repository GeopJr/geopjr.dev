import { readdirSync } from 'fs';
import { join, parse } from 'path';

const options = {
	domain: 'https://geopjr.dev/',
	routes: './src/routes/'
};
options.cleanRoutes = options.routes.replace(/^\.?\/(.+)\//, '$1');

/**
 * Checks if route is dynamic/ignored
 * @param {string} x Route name
 * @returns {boolean}
 */
function isDynamic(x) {
	return ['_', '.', '['].filter((y) => x.startsWith(y)).length !== 0;
}

let routes = [];
/**
 * Recursively go through all routes and populate `routes`
 * @param {string} src The new folder
 * @param {string} parent The parent folder
 * @returns {void}
 */
function getRoutes(src = '', parent = options.routes) {
	const currentSrc = join(parent, src);
	const contents = readdirSync(currentSrc, { withFileTypes: true });
	contents
		.filter((x) => !isDynamic(x.name) && x.isDirectory())
		.forEach((x) => {
			getRoutes(x.name, currentSrc);
		});
	contents
		.filter((x) => x.isFile())
		.filter((x) => !isDynamic(x.name) && x.name.toLowerCase().endsWith('.svelte'))
		.forEach((x) => routes.push(parse(join(currentSrc, x.name))));
}
getRoutes();

routes.forEach((x) => {
	const mapEntry = new URL(
		`${x.dir.replace(options.cleanRoutes, '')}/${x.name === 'index' ? '' : x.name}`,
		options.domain
	);
	console.log(mapEntry.href);
});
