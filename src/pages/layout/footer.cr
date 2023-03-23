module GeopJr
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

  class Layout::Footer
    def initialize(@green_icon : String)
    end

    ECR.def_to_s "#{__DIR__}/footer.ecr"
  end
end
