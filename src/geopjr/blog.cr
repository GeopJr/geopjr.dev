module GeopJr
  alias BlogPostEntry = {filename: String, post: BlogPost, html: String, content: String, hidden: Bool}

  class Blog
    class Youtube
      include JSON::Serializable

      property id : String
      property time : String?
      property title : String?
    end

    def initialize(@blog_path : Path)
    end

    private def figure(title : String?, content : String)
      return content if title.nil?

      <<-HTML
      <figure>
        #{content}
        <figcaption>#{title}</figcaption>
      </figure>    
      HTML
    end

    private def image(url : String, alt : String = "")
      <<-HTML
        <img alt="#{alt}" src="#{url}" />
      HTML
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
      res.scan(/^#youtube +(\{.+\})$/mi) do |m|
        youtube_obj = Youtube.from_json(m[-1])
        tag = <<-HTML
          <a title="Watch on YouTube" class="youtube" href="https://www.youtube.com/watch?v=#{youtube_obj.id}#{youtube_obj.time.nil? ? nil : "&t=#{youtube_obj.time}"}">
            #{figure(youtube_obj.title, image("https://img.youtube.com/vi/#{youtube_obj.id}/mqdefault.jpg"))}
          </a>
        HTML
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
        file_domain = post_path.basename(".md")

        fm = frontmatter(post_source)
        next if fm[0].skip == true
        post_source = post_source.sub(fm[1], "")

        post_source = youtube(post_source)
        template = Crustache.parse post_source
        processed_source = Crustache.render template, {
          "GEOPJR_BLOG_ASSETS" => "/assets/images/blog/#{file_domain}",
        }.merge(GeopJr::CONFIG.emotes)

        html = Markd.to_html(processed_source)
        res << {
          filename: file_domain,
          post:     fm[0],
          html:     html,
          content:  remove_tags(html),
          hidden:   fm[0].hidden,
        }
      end

      res
    end
  end
end
