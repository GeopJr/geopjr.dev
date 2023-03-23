module GeopJr
  class SitemapXML
    @entries : Array({url: String, date: String?})

    def initialize(routes = ROUTES, blog_posts = BLOG_POSTS)
      @entries = [] of {url: String, date: String?}

      routes.each_value do |v|
        filename = v[:file] == "index" ? nil : "#{v[:file]}#{EXT}"
        @entries << {url: "#{URL}/#{filename}", date: nil}
      end

      blog_posts.each do |v|
        date = v[:post].updated
        date = v[:post].date if date.nil?

        @entries << {url: "#{URL}/#{BLOG_PATH}/#{v[:filename]}#{EXT}", date: date.to_s("%Y-%m-%d")}
      end
    end

    ECR.def_to_s "#{__DIR__}/sitemap.xml.ecr"
  end
end
