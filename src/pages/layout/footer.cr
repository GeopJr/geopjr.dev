module GeopJr
  class FooterImageYAML
    include YAML::Serializable

    property filename : String
    property alt : String
    property pixelated : Bool = false
  end

  class FooterBadgeYAML
    include YAML::Serializable

    property filename : String
    property alt : String
    property link : String? = nil
  end

  class Footer
    include YAML::Serializable

    property images : Array(FooterImageYAML)
    property badges : Array(FooterBadgeYAML)
  end

  class Layout::Footer
    @badges : Array(FooterBadgeYAML)

    def initialize
      @badges = CONFIG.data.footer.badges.shuffle
    end

    ECR.def_to_s "#{__DIR__}/footer.ecr"
  end
end
