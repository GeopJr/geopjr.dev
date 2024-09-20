module GeopJr
  @[YAML::Serializable::Options(emit_nulls: true)]
  class Work
    include YAML::Serializable

    property name : String
    property desc : String
    property icon : String?
    property image : String?
    property techs : Array(String)
    property links : Array(WorkLink)
  end

  class WorkLink
    include YAML::Serializable

    property icon : String
    property url : String
    property tooltip : String
  end

  class Page::Work < Page::Base
    def initialize(@works : Array(GeopJr::Work) = GeopJr::CONFIG.data.works)
      super()
    end

    def id : Symbol
      :work
    end

    def description : String
      "Notable & interesting projects I authored"
    end

    def tags : GeopJr::Tags
      @tags
    end

    protected def content : String
      self.to_s
    end

    ECR.def_to_s "#{__DIR__}/work.ecr"
  end
end
