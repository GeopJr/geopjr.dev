module GeopJr
  class RSSXML
    @entries : Array({url: String, date: String, title: String})

    def initialize(blog_posts = BLOG_POSTS)
      @entries = [] of {url: String, date: String, title: String}

      blog_posts.reject { |i| i[:hidden] }.each do |v|
        @entries << {url: "#{GeopJr::CONFIG.url}/#{GeopJr::CONFIG.blog_out_path}/#{v[:filename]}#{GeopJr::CONFIG.ext}", date: v[:post].date.to_rfc2822, title: v[:post].title}
      end
    end

    ECR.def_to_s "#{__DIR__}/rss.xml.ecr"
  end
end
