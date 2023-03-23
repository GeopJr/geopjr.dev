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

    ECR.def_to_s "#{__DIR__}/home.ecr"
  end
end
