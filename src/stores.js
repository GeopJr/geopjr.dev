import { writable } from 'svelte/store';

const themesObj = {
	dark: ['amanita muscaria', 'amanita pantherina'],
	light: ['amanita caesarea', 'amanita phalloides']
};

Object.values(themesObj).forEach((x) => {
	(themesObj.contrast || (themesObj.contrast = [])).push(x[0]);
	(themesObj.noContrast || (themesObj.noContrast = [])).push(x[1]);
});

export const themes = themesObj;
export const theme = writable(themes.dark[0]);
export const eggHint = writable(false);
