import { redirect } from '@sveltejs/kit';

/** @type {import('./$types').PageServerLoad} */
export async function load({ params }) {
    const slug = params.slug.replaceAll(' ', '').replace(/\/\/+/g, '/');
    const parts = slug.split('/').filter((n) => n && n !== '');
    const posts = [];
    let tags = [];

    const modules = import.meta.glob('../*.md', { eager: true, import: 'metadata' });
    for (const path in modules) {
        const metadata = modules[path];
        const slugMd = path.split('.').slice(1, -1).join('.').substring(1);

        const post = {
            name: metadata.title,
            desc: metadata.subtitle,
            date: metadata.updated?.split('T')[0] ?? metadata.date?.split('T')[0],
            techs: metadata.tags,
            links: [
                {
                    icon: 'eye',
                    url: `${__BLOG_BASE__}${slugMd}`,
                    tooltip: 'Read More'
                }
            ]
        };

        posts.push(post);
        tags = tags.concat(metadata.tags);
    }

    tags = tags.map((x) => x.toLowerCase()).sort();
    tags = ['all', ...new Set(tags)];

    // If there's no slug, return all posts
    if (slug === '') {
        return {
            tag: '',
            posts,
            tags: tags.slice(1)
        };
    } else if (
        // else if there are more than 2 slashes (/tag/{tag}) OR there are no parts after filtering OR the first part is not one of the allowed names
        // redirect to blog
        parts.length > 2 ||
        parts.length === 0 ||
        !__BLOG_TAG_SLUG__.includes(parts[0].toLowerCase())
    ) {
        throw parts.length > 2 || parts.length === 0 || !__BLOG_TAG_SLUG__.includes(parts[0].toLowerCase())
        throw redirect(301, '/blog');
    }

    const tag = `${parts[1]?.toLowerCase() ?? ''}`
    return {
        tag,
        posts: tag === '' ? posts : posts.filter((x) => x.techs.map((x) => x.toLowerCase()).includes(tag.toLowerCase())),
        tags: tags.filter((x) => x.toLowerCase() !== tag)
    };
}