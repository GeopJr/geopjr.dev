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

  # class FooterImage
  #   @images : Array(FooterImageYAML) = CONFIG.data.footer.images.shuffle

  #   def initialize
  #     @index = -1
  #   end

  #   def next_image : FooterImageYAML
  #     @index = @index + 1
  #     @images[@index % @images.size]
  #   end
  # end

  # FOOTER_IMAGE = FooterImage.new

  class Layout::Footer
    @badges : Array(FooterBadgeYAML)

    def initialize # @random_image : FooterImageYAML = FOOTER_IMAGE.next_image
      @badges = CONFIG.data.footer.badges.shuffle
    end

    ECR.def_to_s "#{__DIR__}/footer.ecr"
  end
end
