module GeopJr
  module RSSXML
    def self.generate(path : Path)
      File.open(path, "w") do |file|
        file.print <<-XML
          <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
            <channel>
              <title>GeopJr's Blog</title>
              <link>#{GeopJr::CONFIG.url}</link>
              <description>#{HTML.escape(BLOG_DESCRIPTION)}</description>
              <language>en-us</language>
              <atom:link href="#{GeopJr::CONFIG.url}/rss.xml" rel="self" type="application/rss+xml" />
              <generator>GeopJr #{GeopJr::CONFIG.version}</generator>
        XML

        BLOG_POSTS.each do |v|
          next if i.fm.hidden

          # we need to regenerate the blog posts
          # without all the styling and features
          file.print RSSXML::Item.new(v, v.to_html(rss: true)).to_s
        end

        file.print <<-XML
            </channel>
          </rss>
        XML
      end
    end
  end
end
