module GeopJr
  class Page::Contact < Page::Base
    def description : String
      "Where to contact me"
    end

    def id : Symbol
      :contact
    end

    protected def content : String
      Page::CardGrid.new(GeopJr::CONFIG.data.contact, "Contact me on").to_s
    end
  end
end
