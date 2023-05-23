require "html"
require "ecr"
require "yaml"
require "cor"
require "markd"
require "file_utils"

require "./**"

class GeopJr::Config
  getter version : String = "0.2.0"
  getter blog_out_path : String = "blog"
  getter url : String = "https://geopjr.dev"
  getter html_ext : Bool = false
  getter max_posts_per_page : Int32 = 9

  getter ext : String
  getter time_now : Time = Time.utc
  getter paths = {
    out:    Path["dist"],
    static: Path["static"],
    assets: Path["dist"] / "assets",
    icons:  Path["static"] / "_icons",
  }
  getter data = {
    dict:    Hash(String, String).from_yaml({{read_file("./data/dict.yaml")}}),
    colors:  Hash(String, {background: String, text: String}).from_yaml({{read_file("./data/colors.yaml")}}),
    brands:  Hash(String, {background: String, text: String}).from_yaml({{read_file("./data/brands.yaml")}}),
    contact: Hash(String, String).from_yaml({{read_file("./data/contact.yaml")}}),
    donate:  Hash(String, String).from_yaml({{read_file("./data/donate.yaml")}}),
    icons:   Hash(String, String).from_yaml({{read_file("./data/icon_names.yaml")}}),
    about:   About.from_yaml({{read_file("./data/about.yaml")}}),
    works:   Array(Work).from_yaml({{read_file("./data/work.yaml")}}),
  }

  def initialize
    @ext = @html_ext ? ".html" : ""
  end
end

module GeopJr
  CONFIG     = GeopJr::Config.new
  GeopJr::Utils.prepare_output_dir
  BLOG_POSTS = Blog.new(Path["blog"]).generate_blog_posts

  navbar = Layout::Navbar.new("blog").to_s
  footer_icon = FooterIcon.new

  # 404.html
  File.write(
    GeopJr::CONFIG.paths[:out] / "404.html",
    Layout::Page.new(
      Page::NotFound.new.to_s,
      navbar,
      Layout::Footer.new(footer_icon.next_icon).to_s,
      GeopJr::Tags.new(
        "Error - GeopJr",
        "404 Not Found",
        "#{GeopJr::CONFIG.url}/404.html",
        Styles[:error],
        ["error"],
      )
    ).to_s
  )

  # All blog posts
  BLOG_POSTS.each do |v|
    File.write(
      GeopJr::CONFIG.paths[:out] / "blog" / "#{v[:filename]}.html",
      Layout::Page.new(
        Page::Blog::Post.new(v[:post], v[:html]).to_s,
        navbar,
        Layout::Footer.new(footer_icon.next_icon).to_s,
        GeopJr::Tags.new(
          "#{v[:post].title} - GeopJr",
          "#{v[:post].subtitle.nil? ? nil : "#{v[:post].subtitle} - "}#{v[:content][0..100]}...",
          "#{GeopJr::CONFIG.url}/blog/#{v[:filename]}",
          Styles[:blog_post]
        )
      ).to_s
    )
  end

  # Blog pagination
  BLOG_POST_PAGINATION = BlogPagination.new(BLOG_POSTS).pages

  BLOG_POST_PAGINATION.each_with_index do |blog_page, page|
    File.write(
      GeopJr::CONFIG.paths[:out] / "blog" / "#{page + 1}.html",
      Layout::Page.new(
        blog_page.to_s,
        navbar,
        Layout::Footer.new(footer_icon.next_icon).to_s,
        GeopJr::Tags.new(
          "Blog - Page #{page + 1} - GeopJr",
          "Blog posts about programming, tech, ethics, climate, politics & more",
          "#{GeopJr::CONFIG.url}/blog/#{page + 1}",
          Styles[:blog]
        )
      ).to_s
    )
  end

  # Routes
  ROUTES = {
    "home" => {
      title:       "Home",
      page:        Page::Home.new(GeopJr::CONFIG.data[:about].about, GeopJr::CONFIG.data[:about].interests, GeopJr::CONFIG.data[:about].whatido, GeopJr::CONFIG.data[:about].stack).to_s,
      file:        "index",
      description: "Personal Portfolio - CS @ NKUA - Ethical Tech - Blogs about programming, tech, ethics, climate & more",
      style:       Styles[:about],
      script:      ["egg_basket"],
    },
    "work" => {
      title:       "Work",
      page:        Page::Work.new(GeopJr::CONFIG.data[:works]).to_s,
      file:        "work",
      description: "Notable & interesting projects I authored",
      style:       Styles[:work],
      script:      nil,
    },
    "blog" => {
      title:       "Blog",
      page:        BLOG_POST_PAGINATION[0].to_s,
      file:        "blog",
      description: "Blog posts about programming, tech, ethics, climate, politics & more",
      style:       Styles[:blog],
      script:      nil,
    },
    "donate" => {
      title:       "Donate",
      page:        Page::CardGrid.new(GeopJr::CONFIG.data[:donate], "Donate using").to_s,
      file:        "donate",
      description: "Help me continue doing what I love",
      style:       Styles[:donate],
      script:      nil,
    },
    "contact" => {
      title:       "Contact",
      page:        Page::CardGrid.new(GeopJr::CONFIG.data[:contact], "Contact me on").to_s,
      file:        "contact",
      description: "Where to contact me",
      style:       Styles[:contact],
      script:      nil,
    },
  }

  ROUTES.each do |k, v|
    navbar = Layout::Navbar.new(k).to_s

    File.write(
      GeopJr::CONFIG.paths[:out] / "#{v[:file]}.html",
      Layout::Page.new(
        v[:page],
        navbar,
        Layout::Footer.new(
          footer_icon.next_icon
        ).to_s,
        GeopJr::Tags.new(
          "#{v[:file] == "index" ? nil : "#{v[:title]} - "}GeopJr",
          v[:description],
          "#{GeopJr::CONFIG.url}/#{v[:file] == "index" ? nil : v[:file]}",
          v[:style],
          v[:script],
        )
      ).to_s
    )
  end

  # Icons to sprites
  GeopJr::Icons.new(GeopJr::CONFIG.paths[:icons], GeopJr::CONFIG.paths[:assets] / "icons").generate_sprites

  # Move static files to /assets/
  Dir.each_child(GeopJr::CONFIG.paths[:static]) do |static_sub|
    next if static_sub.starts_with?("_")
    FileUtils.cp_r(GeopJr::CONFIG.paths[:static] / static_sub, GeopJr::CONFIG.paths[:out])
  end

  # sitemap.xml
  File.write(GeopJr::CONFIG.paths[:out] / "sitemap.xml", SitemapXML.new.to_s)

  # rss.xml
  File.write(GeopJr::CONFIG.paths[:out] / "rss.xml", RSSXML.new.to_s)

  # Delete underscore files
  FileUtils.rm_rf(Dir.glob(GeopJr::CONFIG.paths[:out] / "**" / "*").select { |x| File.basename(x).starts_with?("_") })
end
