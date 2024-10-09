require "html"
require "ecr"
require "yaml"
require "cor"
require "markd"
require "crustache"
require "csv"
require "file_utils"
require "uri"

require "./**"

class GeopJr::Config
  class Data
    macro load_or_embed(path)
      File.exists?({{path}}) ? File.open({{path}}) : {{read_file(path)}}
    end

    getter dict : Hash(String, String)
    getter colors : Hash(String, {background: String, text: String})
    getter brands : Hash(String, {background: String, text: String})
    getter contact : Hash(String, String)
    getter donate : Hash(String, String)
    getter icons : Hash(String, String)
    getter about : About
    getter works : Array(Work)
    getter footer : Footer

    def initialize
      @dict = Hash(String, String).from_yaml(load_or_embed("./data/dict.yaml"))
      @colors = Hash(String, {background: String, text: String}).from_yaml(load_or_embed("./data/colors.yaml"))
      @brands = Hash(String, {background: String, text: String}).from_yaml(load_or_embed("./data/brands.yaml"))
      @contact = Hash(String, String).from_yaml(load_or_embed("./data/contact.yaml"))
      @donate = Hash(String, String).from_yaml(load_or_embed("./data/donate.yaml"))
      @icons = Hash(String, String).from_yaml(load_or_embed("./data/icon_names.yaml"))
      @about = About.from_yaml(load_or_embed("./data/about.yaml"))
      @works = Array(Work).from_yaml(load_or_embed("./data/work.yaml"))
      @footer = Footer.from_yaml(load_or_embed("./data/footer.yaml"))
    end
  end

  getter version : String = "0.3.0"
  getter blog_out_path : String = "blog"
  getter url : String = "https://geopjr.dev"
  getter title : String = "GeopJr"
  getter html_ext : Bool = false
  getter max_posts_per_page : Int32 = 9

  getter distro_name : String? = nil
  getter ext : String
  getter time_now : Time = Time.utc
  getter paths = {
    out:    Path["dist"],
    static: Path["static"],
    assets: Path["dist", "assets"],
    icons:  Path["static", "_icons"],
  }
  getter data = Data.new
  getter emotes : Hash(String, String) = Hash(String, String).new

  def initialize
    @ext = @html_ext ? ".html" : ""

    if !(os_info = {{read_file?(env("GEOPJR_OS_RELEASE") || "/etc/os-release")}}).nil?
      csv_hash = CSV.parse(os_info, '=').to_h
      @distro_name = csv_hash.fetch("PRETTY_NAME", csv_hash["NAME"]?)
    end

    emotes_dir = Path["static", "assets", "images", "emotes"]
    if Dir.exists?(emotes_dir)
      emotes_parent = Path["/"].join(emotes_dir.parts.skip(1))
      Dir.children(emotes_dir).each do |emote|
        emotes["GEOPJR_EMOTES_#{Path[emote].stem.upcase}"] = (emotes_parent / URI.encode_path(emote)).to_s
      end
    end
  end
end

module GeopJr
  CONFIG     = GeopJr::Config.new
  GeopJr::Utils.prepare_output_dir
  BLOG_POSTS = Blog.new(Path["blog"]).generate_blog_posts

  Page::NotFound.new.write # 404.html
  Blog.write_blog_posts    # Blog Posts

  BLOG_PAGES = BlogPagination.new(BLOG_POSTS)
  BLOG_PAGES.write

  # Routes
  ROUTES = {
    Page::Home.new,
    Page::Work.new,
    BLOG_PAGES.main,
    Page::Donate.new,
    Page::Contact.new,
  }

  ROUTES.each do |route|
    route.write
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
