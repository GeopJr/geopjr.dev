module GeopJr
  class About
    include YAML::Serializable

    property about : String
    property interests : Array(String)
    property whatido : String
    property stack : Hash(String, Hash(String, String))
  end

  class Page::Home
    def initialize(@about : String, @interests : Array(String), @whatido : String, @stack : Hash(String, Hash(String, String)))
    end

    # ECR.def_to_s

    def to_s(io)
      source = ECR.render "#{__DIR__}/home.ecr"
      template = Crustache.parse source
      processed_source = Crustache.render template, {
        "GEOPJR_WORK" => "<a href=\"/work#{GeopJr::CONFIG.ext}\">Work</a>",
        "GEOPJR_2017" => Time.local(Time::Location.load("Europe/Athens")).year - 2017,
      }

      io << processed_source
    end
  end
end
