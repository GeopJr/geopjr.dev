module GeopJr
  class Layout::Navbar
    def initialize(@active_link : String | Symbol)
      @active_link = @active_link.to_s
    end

    ECR.def_to_s "#{__DIR__}/navbar.ecr"
  end
end
