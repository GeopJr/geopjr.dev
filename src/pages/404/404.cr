module GeopJr
  class Page::NotFound < Page::Base
    def initialize
      @tags = GeopJr::Tags.new(
        "Error",
        description,
        id,
        Styles[:error],
        ["error"],
        cover: {
          "assets/images/opengraph/404.png",
          "Blue background with white centered text. Top 'Evangelos \"GeopJr\" Paterakis'. Center '404' with an ordered-dithered old white monitor, keyboard and mouse with some tulips in a pot in front of the first 4. Below the '404' there's a right align 'not found' in monospace. At the bottom there's an ordered dithered gradient.",
          true,
        }
      )
    end

    def description : String
      "404 Not Found"
    end

    def id : Symbol
      :"404"
    end

    protected def content : String
      self.to_s
    end

    ECR.def_to_s "#{__DIR__}/404.ecr"
  end
end
