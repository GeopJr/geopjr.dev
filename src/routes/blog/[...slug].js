/** @type {import('./__types/[...slug]').RequestHandler} */
export async function GET({ params }) {
    const slug = params.slug.replaceAll(' ', '').replace(/\/\/+/g, '/');
    const parts = slug.split('/').filter((n) => n && n !== '');
    const posts = [];
    let tags = [];

    const modules = import.meta.glob('./*.md', { eager: true, import: 'metadata' });
    for (const path in modules) {
        const metadata = modules[path];
        const slug = path.split('.').slice(0, -1).join('.').substring(1);


        const post = {
            name: metadata.title,
            desc: metadata.subtitle,
            date: metadata.updated?.split('T')[0] ?? metadata.date?.split('T')[0],
            techs: metadata.tags,
            links: [
                {
                    icon: 'eye',
                    url: `${__BLOG_BASE__}${slug}`,
                    tooltip: 'Read More'
                }
            ]
        };

        posts.push(post);
        tags = tags.concat(metadata.tags);
    }

    tags = tags.map((x) => x.toLowerCase()).sort();
    tags = ['all', ...new Set(tags)];

    // If there's no slug, rrturn all posts
    if (slug === '') {
        return {
            status: 200,
            body: {
                tag: '',
                posts,
                tags: tags.slice(1)
            }
        };
    } else if (
        // else if there are more than 2 slashes (/tag/{tag}) OR there are no parts after filtering OR the first part is not one of the allowed names
        // redirect to blog
        parts.length > 2 ||
        parts.length === 0 ||
        !__BLOG_TAG_SLUG__.includes(parts[0].toLowerCase())
    ) {
        return {
            status: 301,
            headers: {
                location: "/blog"
            }
        };
    }

    const tag = `${parts[1]?.toLowerCase() ?? ''}`
    return {
        status: 200,
        body: {
            tag,
            posts: tag === '' ? posts : posts.filter((x) => x.techs.map((x) => x.toLowerCase()).includes(tag.toLowerCase())),
            tags: tags.filter((x) => x.toLowerCase() !== tag)
        }
    };
}