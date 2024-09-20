module GeopJr
  class BlogPagination
    @pages : Array(Page::Blog) = [] of Page::Blog

    def initialize(@posts : Array(BlogPostEntry))
      @posts = @posts.reject { |i| i.fm.hidden }
      max_pages = @posts.size.tdiv(GeopJr::CONFIG.max_posts_per_page + 1) + 1
      page = 1

      @posts.sort { |a, b| b.fm.date.to_unix <=> a.fm.date.to_unix }.each_slice(GeopJr::CONFIG.max_posts_per_page) do |blog_page_entries|
        @pages << Page::Blog.new(blog_page_entries, page, max_pages)
        page = page + 1
      end
    end

    def write
      @pages.each(&.write)
    end

    def main : Page::Blog::Main
      Page::Blog::Main.new(@pages[0])
    end
  end

  BLOG_DESCRIPTION = "Blog posts about programming, tech, ethics, climate, politics & more"

  class Page::Blog < Page::Base
    def initialize(@posts : Array(BlogPostEntry), @page : Int32, @max_pages : Int32)
      @tags = GeopJr::Tags.new(
        "Blog - Page #{@page}",
        description,
        "blog/#{@page}",
        Styles[id]
      )
    end

    def id : Symbol
      :blog
    end

    def description : String
      BLOG_DESCRIPTION
    end

    def tags : GeopJr::Tags
      @tags
    end

    protected def content : String
      self.to_s
    end

    def write
      File.write(
        GeopJr::CONFIG.paths[:out] / "blog" / "#{@page}.html",
        Layout::Page.new(
          content,
          Layout::Navbar.new(id).to_s,
          Layout::Footer.new.to_s,
          @tags
        ).to_s
      )
    end

    ECR.def_to_s "#{__DIR__}/blog.ecr"
  end

  class Page::Blog::Main < Page::Base
    def initialize(@page : Page::Blog)
      super()
    end

    def id : Symbol
      :blog
    end

    def description : String
      BLOG_DESCRIPTION
    end

    def tags : GeopJr::Tags
      @tags
    end

    protected def content : String
      @page.to_s
    end
  end
end
