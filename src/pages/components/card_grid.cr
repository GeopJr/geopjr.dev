module GeopJr
  class Page::CardGrid
    def initialize(@cards : Hash(String, String), @title_prefix : String)
    end

    ECR.def_to_s "#{__DIR__}/card_grid.ecr"
  end
end
