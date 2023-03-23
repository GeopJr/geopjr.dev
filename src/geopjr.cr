require "html"
require "ecr"
require "yaml"
require "cor"
require "markd"
require "file_utils"

require "./**"

module GeopJr
  VERSION  = "0.1.0"
  TIME_NOW = Time.utc
  PATHS    = {
    out:    Path["dist"],
    static: Path["static"],
    assets: Path["dist"] / "assets",
    icons:  Path["static"] / "_icons",
  }
  BLOG_PATH      = "blog"
  URL            = "https://geopjr.dev"
  HTML_EXT       = false
  MAX_POSTS_PAGE = 9

  DICT       = Hash(String, String).from_yaml({{read_file("./data/dict.yaml")}})
  COLORS     = Hash(String, {background: String, text: String}).from_yaml({{read_file("./data/colors.yaml")}})
  BRANDS     = Hash(String, {background: String, text: String}).from_yaml({{read_file("./data/brands.yaml")}})
  CONTACT    = Hash(String, String).from_yaml({{read_file("./data/contact.yaml")}})
  DONATE     = Hash(String, String).from_yaml({{read_file("./data/donate.yaml")}})
  ICON_NAMES = Hash(String, String).from_yaml({{read_file("./data/icon_names.yaml")}})
  EXT        = HTML_EXT ? ".html" : ""

  ABOUT = About.from_yaml({{read_file("./data/about.yaml")}})
  WORKS = Array(Work).from_yaml({{read_file("./data/work.yaml")}})

  FileUtils.rm_rf(PATHS[:out]) if Dir.exists?(PATHS[:out])
  Dir.mkdir(PATHS[:out])
  Dir.mkdir(PATHS[:out] / BLOG_PATH)

  BLOG_POSTS = Blog.new(Path["blog"]).generate_blog_posts

  navbar = Layout::Navbar.new("blog").to_s
  footer_icon = FooterIcon.new

  # 404.html
  File.write(PATHS[:out] / "404.html", Layout::Page.new(Page::NotFound.new.to_s, navbar, Layout::Footer.new(footer_icon.next_icon).to_s, {
    title:       "Error - GeopJr",
    description: "404 Not Found",
    url:         "#{URL}/404.html",
    style:       Styles[:error],
    script:      ["error"],
  }).to_s)

  # All blog posts
  BLOG_POSTS.each do |v|
    bpost = Page::Blog::Post.new(v[:post], v[:html]).to_s

    tags = {
      title:       "#{v[:post].title} - GeopJr",
      description: "#{v[:post].subtitle.nil? ? nil : "#{v[:post].subtitle} - "}#{v[:content][0..100]}...",
      url:         "#{URL}/blog/#{v[:filename]}",
      style:       Styles[:blog_post],
      script:      [] of String,
    }

    File.write(PATHS[:out] / "blog" / "#{v[:filename]}.html", Layout::Page.new(bpost, navbar, Layout::Footer.new(footer_icon.next_icon).to_s, tags).to_s)
  end

  # Blog pagination
  BLOG_POST_PAGINATION = BlogPagination.new(BLOG_POSTS).pages

  BLOG_POST_PAGINATION.each_with_index do |blog_page, page|
    File.write(PATHS[:out] / "blog" / "#{page + 1}.html", Layout::Page.new(blog_page.to_s, navbar, Layout::Footer.new(footer_icon.next_icon).to_s, {
      title:       "Blog - Page #{page + 1} - GeopJr",
      description: "Blog posts about programming, tech, ethics, climate, politics & more",
      url:         "#{URL}/blog/#{page + 1}",
      style:       Styles[:blog],
      script:      [] of String,
    }).to_s)
  end

  # Routes
  ROUTES = {
    "home" => {
      title:       "Home",
      page:        Page::Home.new(ABOUT.about, ABOUT.interests, ABOUT.whatido, ABOUT.stack).to_s,
      file:        "index",
      description: "Personal Portfolio - CS @ NKUA - Ethical Tech - Blogs about programming, tech, ethics, climate & more",
      style:       Styles[:about],
      script:      ["egg_basket"],
    },
    "work" => {
      title:       "Work",
      page:        Page::Work.new(WORKS).to_s,
      file:        "work",
      description: "Notable & interesting projects I authored",
      style:       Styles[:work],
      script:      [] of String,
    },
    "blog" => {
      title:       "Blog",
      page:        BLOG_POST_PAGINATION[0].to_s,
      file:        "blog",
      description: "Blog posts about programming, tech, ethics, climate, politics & more",
      style:       Styles[:blog],
      script:      [] of String,
    },
    "donate" => {
      title:       "Donate",
      page:        Page::CardGrid.new(DONATE, "Donate using").to_s,
      file:        "donate",
      description: "Help me continue doing what I love",
      style:       Styles[:donate],
      script:      [] of String,
    },
    "contact" => {
      title:       "Contact",
      page:        Page::CardGrid.new(CONTACT, "Contact me on").to_s,
      file:        "contact",
      description: "Where to contact me",
      style:       Styles[:contact],
      script:      [] of String,
    },
  }

  ROUTES.each do |k, v|
    navbar = Layout::Navbar.new(k).to_s
    tags = {
      title:       "#{v[:file] == "index" ? nil : "#{v[:title]} - "}GeopJr",
      description: v[:description],
      url:         "#{URL}/#{v[:file] == "index" ? nil : v[:file]}",
      style:       v[:style],
      script:      v[:script],
    }

    File.write(PATHS[:out] / "#{v[:file]}.html", Layout::Page.new(v[:page], navbar, Layout::Footer.new(footer_icon.next_icon).to_s, tags).to_s)
  end

  # Icons to sprites
  GeopJr::Icons.new(PATHS[:icons], PATHS[:assets] / "icons").generate_sprites

  # Move static files to /assets/
  Dir.each_child(PATHS[:static]) do |static_sub|
    next if static_sub.starts_with?("_")
    FileUtils.cp_r(PATHS[:static] / static_sub, PATHS[:out])
  end

  # sitemap.xml
  File.write(PATHS[:out] / "sitemap.xml", SitemapXML.new.to_s)

  # Delete underscore files
  FileUtils.rm_rf(Dir.glob(PATHS[:out] / "**" / "*").select { |x| File.basename(x).starts_with?("_") })
end
