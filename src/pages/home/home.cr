module GeopJr
  class About
    include YAML::Serializable

    property about : String
    property interests : Array(String)
    property whatido : String
    property stack : Hash(String, Hash(String, String))
  end

  class Page::Home < Page::Base
    def initialize(@about : About = GeopJr::CONFIG.data.about)
      @tags = GeopJr::Tags.new(
        nil,
        description,
        nil,
        Styles[:about],
        ["egg_basket"],
      )
    end

    def id : Symbol
      :home
    end

    def description : String
      "Personal Portfolio - CS @ NKUA - Ethical Tech - Blogs about programming, tech, ethics, climate & more"
    end

    def tags : GeopJr::Tags
      @tags
    end

    protected def content : String
      self.to_s
    end

    def write
      File.write(
        GeopJr::CONFIG.paths[:out] / "index.html",
        Layout::Page.new(
          content,
          Layout::Navbar.new(id).to_s,
          Layout::Footer.new.to_s,
          @tags
        ).to_s
      )
    end

    def to_s(io)
      source = ECR.render "#{__DIR__}/home.ecr"
      template = Crustache.parse source
      processed_source = Crustache.render template, {
        "GEOPJR_WORK" => "<a href=\"/work#{GeopJr::CONFIG.ext}\">Work</a>",
        "GEOPJR_2017" => Time.local(Time::Location.load("Europe/Athens")).year - 2017,
      }

      io << processed_source
    end
  end
end
