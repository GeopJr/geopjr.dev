module GeopJr
  alias BlogPostEntry = {filename: String, post: BlogPost, html: String, content: String}

  class Blog
    def initialize(@blog_path : Path)
    end

    private def remove_tags(content : String) : String
      content.gsub(/<[^>]*>/, "").gsub("\n", " ").gsub("  ", " ")
    end

    # Splits a blog post with frontmatter
    # into BlogPost and frontmatter unparsed
    private def frontmatter(content : String) : {BlogPost, String}
      fm = content.match(/^---\n(.+)---\n/m).not_nil![0]
      fm_parsed = BlogPost.from_yaml(fm)
      {fm_parsed, fm}
    end

    # Turns <youtube> custom elements into
    # an anchor with its thumbnail
    private def youtube(content : String) : String
      res = content
      res.scan(/<youtube id="([a-zA-Z0-9]+)" ?(time="([a-zA-Z0-9]+)")? ?\/>/) do |m|
        tag = "<a title=\"Watch on YouTube\" class=\"youtube\" href=\"https://www.youtube.com/watch?v=#{m[1]}#{m.size == 4 ? "&t=#{m[-1]}" : nil}\"><img aria-hidden=\"true\" src=\"https://img.youtube.com/vi/#{m[1]}/mqdefault.jpg\" /></a>"
        res = res.sub(m[0], tag)
      end
      res
    end

    def generate_blog_posts : Array(BlogPostEntry)
      res = [] of BlogPostEntry
      Dir.each_child(@blog_path) do |post|
        next if post.starts_with?("_")

        post_path = @blog_path / post
        post_source = File.read(post_path)

        fm = frontmatter(post_source)
        next if fm[0].skip == true
        post_source = post_source.sub(fm[1], "")

        post_source = youtube(post_source)
        html = Markd.to_html(post_source)

        res << {
          filename: post_path.basename(".md"),
          post:     fm[0],
          html:     html,
          content:  remove_tags(html),
        }
      end

      res
    end
  end
end
