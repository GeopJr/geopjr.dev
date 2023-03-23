module GeopJr
  class BlogPagination
    getter pages : Array(Page::Blog) = [] of Page::Blog

    def initialize(@posts : Array(BlogPostEntry))
      max_pages = @posts.size.tdiv(MAX_POSTS_PAGE + 1) + 1
      page = 1

      @posts.sort { |a, b| b[:post].date.to_unix <=> a[:post].date.to_unix }.each_slice(MAX_POSTS_PAGE) do |blog_page_entries|
        @pages << Page::Blog.new(blog_page_entries, page, max_pages)
        page = page + 1
      end
    end
  end

  class Page::Blog
    def initialize(@posts : Array(BlogPostEntry), @page : Int32, @max_pages : Int32)
    end

    ECR.def_to_s "#{__DIR__}/blog.ecr"
  end
end
