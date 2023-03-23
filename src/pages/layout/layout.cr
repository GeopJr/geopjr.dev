module GeopJr
  class Layout::Page
    def initialize(@content : String, @navbar : String, @footer : String, @tags : GeopJr::TagsObj)
    end

    ECR.def_to_s "#{__DIR__}/layout.ecr"
  end
end
