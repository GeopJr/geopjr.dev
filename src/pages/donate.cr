module GeopJr
  class Page::Donate < Page::Base
    @hidden = true

    def description : String
      "Help me continue doing what I love"
    end

    def id : Symbol
      :donate
    end

    protected def content : String
      Page::CardGrid.new(GeopJr::CONFIG.data.donate, "Donate using").to_s
    end
  end
end
