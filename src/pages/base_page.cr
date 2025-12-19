module GeopJr
  abstract class Page::Base
    getter tags : Tags
    getter hidden : Bool = false
    getter header : String? = nil

    def initialize
      @tags = GeopJr::Tags.new(
        title,
        description,
        id,
        Styles[id]
      )
    end

    def title
      id.to_s.capitalize
    end

    def write
      File.write(
        GeopJr::CONFIG.paths[:out] / "#{id}.html",
        Layout::Page.new(
          content,
          Layout::Navbar.new(id).to_s,
          Layout::Footer.new.to_s,
          @tags,
          @header
        ).to_s
      )
    end

    abstract def description : String
    abstract def id : Symbol
    protected abstract def content : String
  end
end
