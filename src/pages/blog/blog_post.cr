module GeopJr
  @[YAML::Serializable::Options(emit_nulls: true)]
  class BlogPostFrontmatter
    include YAML::Serializable

    @[YAML::Serializable::Options(emit_nulls: true)]
    class Bandcamp
      include YAML::Serializable

      property album : Int64
      property track : Int64? = nil
    end

    property title : String
    property subtitle : String?
    property date : Time
    property updated : Time?
    property tags : Array(String)
    property skip : Bool?
    property hidden : Bool = false
    # redesign covers and re-enable
    property cover : Bool | String = false # string is for alt text
    property bandcamp : Bandcamp? = nil
    property starred : Bool = false
  end

  class Page::Blog::Post
    def initialize(@post : BlogPostFrontmatter, @html : String)
    end

    ECR.def_to_s "#{__DIR__}/blog_post.ecr"
  end
end
