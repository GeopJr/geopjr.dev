module GeopJr
  class Layout::Page
    def initialize(@content : String, @navbar : String, @footer : String, @tags : GeopJr::Tags, @header : String? = nil)
    end

    ECR.def_to_s "#{__DIR__}/layout.ecr"
  end
end
