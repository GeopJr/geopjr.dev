module GeopJr
  Styles = {
    about:     ["about", "wave", "card"],
    blog_post: ["blog_post"],
    blog:      ["card_view", "blog", "card"],
    donate:    ["credit_card_view"],
    contact:   ["credit_card_view"],
    work:      ["card_view", "card"],
    error:     ["error"],
  }

  class Tags
    property title : String
    property description : String
    property url : String
    property css : Array(String)?
    property js : Array(String)?
    property cover : CoverImage

    alias CoverImage = Tuple(String, String)

    def initialize(title : String, description : String, url : String, style : Array(String)? = nil, script : Array(String)? = nil, cover : CoverImage? = nil)
      @title = HTML.escape(title)
      @description = HTML.escape(description)
      @url = HTML.escape(url)
      @css = style
      @js = script

      if cover.nil?
        @cover = {
          "#{GeopJr::CONFIG.url}/assets/favicons/avi.webp",
          "My avatar, a yellow Novakid from the game Starbound",
        }
      else
        @cover = {
          "#{GeopJr::CONFIG.url}/#{cover[0]}",
          "#{cover[1]}",
        }
      end
    end

    def standard
      <<-HTML
          <title>#{@title}</title>
          <meta name="title" content="#{@title}">
          <meta name="description" content="#{@description}">
          <link rel="canonical" href="#{@url}">
          HTML
    end

    def og
      <<-HTML
          <meta property="og:title" content="#{@title}">
          <meta property="og:description" content="#{@description}">
          <meta property="og:url" content="#{@url}">
          <meta property="og:image" content="#{@cover[0]}">
          <meta property="og:image:alt" content="#{@cover[1]}">
          HTML
    end
  end
end
