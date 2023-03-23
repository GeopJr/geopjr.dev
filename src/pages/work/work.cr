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

  class Page::Work
    def initialize(@works : Array(GeopJr::Work))
    end

    ECR.def_to_s "#{__DIR__}/work.ecr"
  end
end
