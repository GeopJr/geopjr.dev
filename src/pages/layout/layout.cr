module GeopJr
  class Layout::Page
    PALETTE = GeopJr::Palette.new

    def initialize(@content : String, @navbar : String, @footer : String, @tags : GeopJr::Tags, @header : String? = nil, @palette : GeopJr::Palette? = PALETTE)
      @palette.not_nil!.next unless @palette.nil?
    end

    ECR.def_to_s "#{__DIR__}/layout.ecr"
  end
end
