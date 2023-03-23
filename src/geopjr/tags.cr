module GeopJr
  alias TagsObj = {title: String, description: String, url: String, style: Array(String), script: Array(String)}

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
    property css : Array(String)
    property js : Array(String)

    def initialize(title : String, description : String, url : String, style : Array(String) = [] of String, script : Array(String) = [] of String)
      @title = HTML.escape(title)
      @description = HTML.escape(description)
      @url = HTML.escape(url)
      @css = style
      @js = script
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
          <meta name="og:title" content="#{@title}">
          <meta name="og:description" content="#{@description}">
          <meta name="og:url" content="#{@url}">
          HTML
    end
  end
end
