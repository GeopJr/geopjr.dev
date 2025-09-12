module GeopJr
  class RSSXML::Item
    @title : String
    @url : String
    @date : String
    @tags : Array(String)
    @content : String

    def initialize(entry : BlogPostEntry, @content : String)
      @title = entry.fm.title
      @url = "#{GeopJr::CONFIG.url}/#{GeopJr::CONFIG.blog_out_path}/#{entry.filename}#{GeopJr::CONFIG.ext}"
      @date = entry.fm.date.to_rfc2822
      @tags = entry.fm.tags
    end

    ECR.def_to_s "#{__DIR__}/item.xml.ecr"
  end
end
