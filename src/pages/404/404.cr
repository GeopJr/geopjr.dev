module GeopJr
  class Page::NotFound < Page::Base
    def initialize
      @tags = GeopJr::Tags.new(
        "Error",
        description,
        id,
        Styles[:error],
        ["error"],
      )
    end

    def description : String
      "404 Not Found"
    end

    def id : Symbol
      :"404"
    end

    def tags : GeopJr::Tags
      @tags
    end

    protected def content : String
      self.to_s
    end

    ECR.def_to_s "#{__DIR__}/404.ecr"
  end
end
