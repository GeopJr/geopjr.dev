module GeopJr
  class SitemapXML
    @entries : Array({url: String, date: String?})

    def initialize(routes = ROUTES, blog_posts = BLOG_POSTS)
      @entries = [] of {url: String, date: String?}

      routes.each_value do |v|
        filename = v[:file] == "index" ? nil : "#{v[:file]}#{GeopJr::CONFIG.ext}"
        @entries << {url: "#{GeopJr::CONFIG.url}/#{filename}", date: nil}
      end

      blog_posts.reject { |i| i[:hidden] }.each do |v|
        date = v[:post].updated || v[:post].date

        @entries << {url: "#{GeopJr::CONFIG.url}/#{GeopJr::CONFIG.blog_out_path}/#{v[:filename]}#{GeopJr::CONFIG.ext}", date: date.to_s("%Y-%m-%d")}
      end
    end

    ECR.def_to_s "#{__DIR__}/sitemap.xml.ecr"
  end
end
