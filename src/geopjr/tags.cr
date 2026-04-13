module GeopJr
  Styles = {
    about:     ["about"],
    blog_post: ["blog_post", "syntax_highlighting"],
    blog:      ["card_view", "blog"],
    donate:    ["credit_card_view"],
    contact:   ["credit_card_view"],
    work:      ["card_view"],
    error:     ["error"],
  }

  class Tags
    property title : String?
    property description : String
    property url : String
    property url_full : String
    property css : Array(String)?
    property js : Array(String)?
    property cover : CoverImage
    property noindex : Bool

    alias CoverImage = Tuple(String, String?, Bool) # Bool => whether it should be cover sized
    COVER_SMALL = {
      "assets/favicons/avi.webp",
      "My avatar, a yellow Novakid from the game Starbound",
      false,
    }
    COVER_BIG = {
      "#{GeopJr::CONFIG.url}/assets/images/opengraph/ogimage.png",
      "Blue background with white centered text. Top left 'Evangelos', middle 'geopjr' in ascii art, bottom right 'Paterakis'. At the bottom left there's an ordered-dithered old white monitor, keyboard and mouse with some tulips in a pot.",
      true,
    }

    def initialize(
      title : String?,
      description : String,
      url : String | Symbol | Nil,
      style : Array(String)? = nil,
      script : Array(String)? = nil,
      cover : CoverImage? = nil,
      @noindex : Bool = false,
    )
      if title.nil?
        @title = GeopJr::CONFIG.title
      else
        @title = "#{HTML.escape(title)} - #{GeopJr::CONFIG.title}"
      end

      case url
      when Symbol
        url = url.to_s
      when Nil
        url = ""
      end

      if url == "" || url.ends_with?('/')
        @url = HTML.escape(url)
      else
        @url = "#{HTML.escape(url)}#{GeopJr::CONFIG.ext}"
      end
      @url_full = Path[GeopJr::CONFIG.url, @url].to_s

      @description = HTML.escape(description)
      @css = style
      @js = script

      if cover.nil?
        @cover = COVER_BIG
      else
        @cover = {
          "#{GeopJr::CONFIG.url}/#{cover[0]}",
          cover[1],
          cover[2],
        }
      end
    end

    def standard
      <<-HTML
          <title>#{@title}</title>
          <meta name="title" content="#{@title}">
          <meta name="description" content="#{@description}">
          <link rel="canonical" href="#{@url_full}">
          #{noindex ? "<meta name=\"robots\" content=\"noindex\">" : nil}
          HTML
    end

    def og
      cover_alt = @cover[1].nil? || @cover[1].try &.strip == "" ? nil : "<meta property=\"og:image:alt\" content=\"#{@cover[1]}\">"
      cover_full = @cover[2] == false ? nil : <<-HTML
          <meta property="og:image:width" content="1200" />
          <meta property="og:image:height" content="630" />
          <meta name="twitter:card" content="summary_large_image">
      HTML

      <<-HTML
          <meta property="og:title" content="#{@title}">
          <meta property="og:description" content="#{@description}">
          <meta property="og:url" content="#{@url_full}">
          <meta property="og:image" content="#{@cover[0]}">
          #{cover_alt}
          #{cover_full}
          HTML
    end
  end
end
