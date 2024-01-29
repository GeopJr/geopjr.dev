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

  class FooterImage
    @images : Array(FooterImageYAML) = CONFIG.data.[:footer].images.shuffle

    def initialize
      @index = -1
    end

    def next_image : FooterImageYAML
      @index = @index + 1
      @images[@index % @images.size]
    end
  end

  class FooterIcon
    enum GreenIcon
      Seedling
      Frog
      Recycle
      Earth
      Leaf
      Staff_Snake
      Alien
    end

    getter icons : Array(String) = GreenIcon.names.shuffle

    def initialize
      @index = -1
    end

    def next_icon : String
      @index = @index + 1
      @icons[@index % @icons.size].downcase.gsub('_', '-')
    end
  end

  FOOTER_ICON  = FooterIcon.new
  FOOTER_IMAGE = FooterImage.new

  class Layout::Footer
    @badges : Array(FooterBadgeYAML)

    def initialize(@green_icon : String = FOOTER_ICON.next_icon, @random_image : FooterImageYAML = FOOTER_IMAGE.next_image)
      @badges = CONFIG.data.[:footer].badges.shuffle
    end

    ECR.def_to_s "#{__DIR__}/footer.ecr"
  end
end
