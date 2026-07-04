class Tartrazine::Html < Tartrazine::Formatter
  def line_label(i : Int32) : String
    line_class = highlighted?(i + 1) ? " #{get_css_class("LineHighlight")}" : ""
    "<span class=\"line-no#{line_class}\"></span>"
  end
end

module GeopJr
  class BlogPostEntry
    class BlogRenderer < Markd::HTMLRenderer
      HEADINGS.map_with_index!(2) do |h, i|
        h = "h#{i}"
      end
      HEADINGS[-1] = HEADINGS[-2]

      property anchors = true
      property rss = false

      def toc(node : Markd::Node)
        return unless node.type.heading? && anchors

        text = String.build do |str|
          walker = node.walker
          while (subnode = walker.next)
            next if !subnode[1]
            stripped_text = subnode[0].text.strip
            next if stripped_text == ""

            str << stripped_text
          end
        end

        title = URI.encode_path_segment(text)
        return if title == ""
        @output_io << %(<a aria-label="Link to this" id=") << title << %(" class="anchor" href="#) << title << %(">#</a>)
        @last_output = ">"
      end

      def code_block(node : Markd::Node, entering : Bool, formatter : T?) : Nil forall T
        if !rss
          final_title = "Code"
          languages = node.fence_language ? node.fence_language.split : nil

          unless languages.nil?
            lang = code_block_language(languages)
            unless lang.nil?
              if languages.size > 1
                final_title = languages[1]
              else
                final_title = lang.size == 2 ? ".#{lang.downcase}" : lang.capitalize
              end
            end
          end

          make_window(true, final_title, "editor")
        end

        if formatter.nil?
          render_code_block_use_code_tag(node)
        else
          super
        end

        if !rss
          make_window(false)
        end
      end

      def block_quote(node : Markd::Node, entering : Bool) : Nil
        if rss
          super
        else
          if entering
            make_window(entering, "Quote", "quote")
            tag("blockquote", attrs(node))
          else
            tag("blockquote", end_tag: true)
            make_window(entering)
          end
        end
      end

      def image(node : Markd::Node, entering : Bool)
        if entering
          if @disable_tag == 0
            destination = node.data["destination"].as(String)
            if @options.safe? && potentially_unsafe(destination)
              literal(%(<img loading="lazy" decoding="async" src="" alt=""))
            else
              destination = resolve_uri(destination, node)
              literal(%(<img loading="lazy" decoding="async" src="#{escape(destination)}" alt="))
            end
          end
          @disable_tag += 1
        else
          @disable_tag -= 1
          if @disable_tag == 0
            if (title = node.data["title"].as(String)) && !title.empty?
              literal(%(" title="#{escape(title)}))
            end
            literal(%(" />))
          end
        end
      end

      private def make_window(entering : Bool, title : String = "", icon : String = "")
        if entering
          tag("article", {"class" => "card"})
          tag("header")
          tag(
            "img",
            {
              "class"       => "c",
              "aria-hidden" => "true",
              "alt"         => "",
              "src"         => "/assets/images/tango/#{icon}.webp",
              "loading"     => "lazy",
              "decoding"    => "async",
              "width"       => "16",
              "height"      => "16",
            }
          )

          tag("span", {"aria-hidden" => "true"}) do
            output(title)
          end
          tag(
            "div",
            {
              "class"       => "window-controls",
              "aria-hidden" => "true",
            }
          )
          tag("span")
          tag("span", end_tag: true)

          tag("span")
          tag("span", end_tag: true)

          tag("span")
          tag("span", end_tag: true)
          tag("div", end_tag: true)

          tag("header", end_tag: true)
          tag("section")
        else
          tag("section", end_tag: true)
          tag("article", end_tag: true)
        end
      end
    end

    class Youtube
      include JSON::Serializable

      property id : String
      property time : String?
      property title : String?
    end

    getter filename : String
    getter fm : BlogPostFrontmatter

    def initialize(@filename : String, @fm : BlogPostFrontmatter, @path : Path, @io_pos_content : Int32 | Int64)
    end

    private def figure(title : String?, content : String)
      return content if title.nil?

      <<-HTML
      <figure>#{content}<figcaption>#{title}</figcaption></figure>
      HTML
    end

    private def image(url : String, alt : String = "")
      <<-HTML
        <img alt="#{alt}" loading="lazy" decoding="async" src="#{url}" />
      HTML
    end

    def self.remove_tags(content : String) : String
      content.gsub(/<[^>]*>/, "").gsub("\n", " ").gsub("  ", " ").strip
    end

    private def note_style(title : String) : {String, String}
      case title.downcase
      when "disclaimer", "warning", "important"
        {"warn.webp", "#faa546"}
      else
        {"info.webp", "#ABB98B"}
      end
    end

    private def note(content : String, rss : Bool = false) : String
      split_content = content.split("\n", 2, remove_empty: true)
      title = split_content[0].strip
      content = render(split_content[-1].strip.split("\n").map(&.strip).join("\n"), rss)

      if rss
        return <<-HTML

          <p><strong>#{title}</strong><br />#{content}</p>

        HTML
      end

      icon, color = note_style(title)
      <<-HTML

        <article class="card" style="--theme-selected-bg:#{color}">
		    	<header>
		    		<img width="16" height="16" class="c" loading="lazy" decoding="async" aria-hidden="true" alt="" src="/assets/images/tango/#{icon}" /><span>#{title}</span>
		    		<div class="window-controls" aria-hidden="true">
		    			<span></span>
		    			<span></span>
		    			<span></span>
		    		</div>
		    	</header>
		    	<section>#{content}</section>
		    </article>

      HTML
    end

    @@markd_options = Markd::Options.new(toc: true)
    @@markd_formatter = Tartrazine::Html.new(
      theme: Tartrazine.theme("gruvbox"),
      line_numbers: true,
      standalone: false,
    )

    def to_html(rss : Bool = false) : String
      processed_source = File.open(@path) do |io|
        io.pos = @io_pos_content if io.pos != @io_pos_content

        template = Crustache.parse io
        Crustache.render template, {
          "GEOPJR_BLOG_ASSETS" => "#{rss ? GeopJr::CONFIG.url : ""}/assets/images/blog/#{@filename}",
          "GEOPJR_EXT"         => GeopJr::CONFIG.ext,
          # Turns <youtube> custom elements into
          # an anchor with its thumbnail
          "YOUTUBE" => ->(tmpl : String, render : String -> String) {
            obj = render.call(tmpl)
            youtube_obj = Youtube.from_json(obj)
            <<-HTML
            <a title="Watch on YouTube" class="youtube" href="https://www.youtube.com/watch?v=#{youtube_obj.id}#{youtube_obj.time.nil? ? nil : "&t=#{youtube_obj.time}"}">
              #{figure(youtube_obj.title, image("https://img.youtube.com/vi/#{youtube_obj.id}/mqdefault.jpg"))}
            </a>
            HTML
          },
          "NOTE" => ->(tmpl : String, render : String -> String) {
            note(render.call(tmpl), rss)
          },
        }.merge(GeopJr::CONFIG.emotes)
      end

      return "" if processed_source.empty?
      render(processed_source, rss)
    end

    def render(source : String, rss : Bool) : String
      renderer = BlogRenderer.new(@@markd_options)
      renderer.anchors = !rss
      renderer.rss = rss
      renderer.render(Markd::Parser.parse(source, @@markd_options), rss ? nil : @@markd_formatter)
    end
  end

  class Blog
    def initialize(@blog_path : Path)
    end

    # Splits a blog post with frontmatter
    # into BlogPostFrontmatter and frontmatter unparsed
    private def self.frontmatter(io : IO) : BlogPostFrontmatter
      fm = IO::Delimited.new(io, "\n---").gets_to_end
      BlogPostFrontmatter.from_yaml(fm)
    end

    def generate_blog_posts : Array(BlogPostEntry)
      res = [] of BlogPostEntry
      Dir.each_child(@blog_path) do |post|
        entry = Blog.generate_blog_post(@blog_path / post)
        res << entry unless entry.nil?
      end

      res.sort { |a, b| b.fm.date.to_unix <=> a.fm.date.to_unix }
    end

    def self.generate_blog_post(path : Path) : BlogPostEntry?
      file_domain = path.basename(".md")
      return if file_domain.starts_with?("_")

      io_fm_pos = 0
      fm = File.open(path) do |post_source|
        res = frontmatter(post_source)
        io_fm_pos = post_source.pos
        res
      end
      return if fm.skip == true

      BlogPostEntry.new(file_domain, fm, path, io_fm_pos)
    end

    def self.write_blog_posts
      blog_navbar = Layout::Navbar.new("blog").to_s

      GeopJr::GENERATOR.@blog_posts.each do |v|
        write_blog_post(v, blog_navbar)
      end
    end

    def self.write_blog_post(entry : BlogPostEntry, blog_navbar : String = Layout::Navbar.new("blog").to_s)
      html = entry.to_html
      File.write(
        GeopJr::CONFIG.paths[:out] / "blog" / "#{entry.filename}.html",
        Layout::Page.new(
          Page::Blog::Post.new(entry.fm, html).to_s,
          blog_navbar,
          Layout::Footer.new.to_s,
          GeopJr::Tags.new(
            entry.fm.title,
            "#{entry.fm.subtitle.nil? ? nil : "#{entry.fm.subtitle} - "}#{BlogPostEntry.remove_tags(html)[0..100]}...",
            "blog/#{entry.filename}",
            Styles[:blog_post],
            cover: entry.fm.cover == false ? GeopJr::Tags::COVER_SMALL : {
              "assets/images/opengraph/#{entry.filename}.png",
              entry.fm.cover.is_a?(String) ? entry.fm.cover.to_s : nil,
              true,
            },
            noindex: entry.fm.hidden
          ),
          ""
        ).to_s
      )
    end
  end
end
