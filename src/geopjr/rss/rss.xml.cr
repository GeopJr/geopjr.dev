module GeopJr
  class RSSXML
    @entries : Array({url: String, date: String, title: String})

    def initialize(blog_posts = BLOG_POSTS)
      @entries = [] of {url: String, date: String, title: String}

      blog_posts.each do |v|
        @entries << {url: "#{URL}/#{BLOG_PATH}/#{v[:filename]}#{EXT}", date: v[:post].date.to_rfc2822, title: v[:post].title}
      end
    end

    ECR.def_to_s "#{__DIR__}/rss.xml.ecr"
  end
end
