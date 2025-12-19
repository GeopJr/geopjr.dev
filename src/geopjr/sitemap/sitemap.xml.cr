module GeopJr
  class SitemapXML
    @entries : Array({url: String, date: String?})

    def initialize(routes = ROUTES, blog_posts = BLOG_POSTS)
      @entries = [] of {url: String, date: String?}

      routes.each do |v|
        next if v.hidden
        @entries << {url: v.tags.url_full, date: nil}
      end

      blog_posts.reject { |i| i.fm.hidden }.each do |v|
        date = v.fm.updated || v.fm.date

        @entries << {url: "#{GeopJr::CONFIG.url}/#{GeopJr::CONFIG.blog_out_path}/#{v.filename}#{GeopJr::CONFIG.ext}", date: date.to_s("%Y-%m-%d")}
      end
    end

    ECR.def_to_s "#{__DIR__}/sitemap.xml.ecr"
  end
end
