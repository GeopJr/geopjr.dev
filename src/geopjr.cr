require "option_parser"
require "html"
require "ecr"
require "yaml"
require "cor"
require "tartrazine"
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

  getter version : String = "0.6.0"
  getter blog_out_path : String = "blog"
  getter url : String = "https://geopjr.dev"
  getter title : String = "Evangelos “GeopJr” Paterakis"
  getter html_ext : Bool = false
  getter max_posts_per_page : Int32 = 25

  getter distro_name : String? = nil
  getter ext : String
  getter time_now : Time = Time.utc
  getter paths = {
    out:    Path["dist"],
    static: Path["static"],
    assets: Path["dist", "assets"],
    icons:  Path["static", "_icons"],
    tools:  Path[".tools"],
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

should_serve = false
just_sass = false
just_minify = false
just_zip = false
just_vips = false

should_sass = true
should_minify = true
should_zip = true

should_watch_sass = false
OptionParser.parse do |parser|
  parser.banner = "Usage: geopjr [arguments]"
  parser.on("serve", "Spawns an HTTP serve that serves the output") { should_serve = true }
  parser.on("sass", "Run the dart-sass command without re-compiling") do
    should_sass = just_sass = true
    parser.banner = "Usage: geopjr sass [arguments]"
    parser.on("-w", "--watch", "Watch for changes") { should_watch_sass = true }
  end
  parser.on("minify", "Run the minify command without re-compiling") { should_minify = just_minify = true }
  parser.on("zip", "Run zip the output without re-compiling") { should_zip = just_zip = true }
  {% unless flag?(:novips) %}
    parser.on("vips", "Run vips-related operations") { just_vips = true }
  {% end %}
  parser.on("--no-sass", "Doesn't compile the SCSS automatically") { should_sass = false }
  parser.on("--no-minify", "Doesn't minify the output automatically") { should_minify = false }
  parser.on("--no-zip", "Doesn't zip the output automatically") { should_zip = false }
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.invalid_option do |flag|
    STDERR.puts "🐱 ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

{% unless flag?(:novips) %}
  if just_vips
    (GeopJr::OGCovers.new).generate(GeopJr::Blog.new(Path["blog"]).generate_blog_posts, GeopJr::CONFIG.paths[:static], true)
    exit
  end
{% end %}

# if it exists, serve (won't continue executing)
# else output and then will run these
if Dir.exists?(GeopJr::CONFIG.paths[:out]) && (just_sass || just_minify || just_zip || should_serve)
  GeopJr::Tools.new(just_sass, just_minify, just_zip, should_watch_sass) if just_sass || just_minify || just_zip
  GeopJr::Server.serve if should_serve
  exit
end

module GeopJr
  CONFIG = GeopJr::Config.new
  GeopJr::Utils.prepare_output_dir

  puts "🐱 Generating blog"
  BLOG_POSTS = Blog.new(Path["blog"]).generate_blog_posts
  Blog.write_blog_posts # Blog Posts
  puts "🐱 Generated blog"

  puts "🐱 Generating routes"
  BLOG_PAGES = BlogPagination.new(BLOG_POSTS)
  BLOG_PAGES.write

  # Routes
  Page::NotFound.new.write # 404.html
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
  puts "🐱 Generated routes"

  # Icons to sprites
  puts "🐱 Generating spritesheets"
  GeopJr::Icons.new(GeopJr::CONFIG.paths[:icons], GeopJr::CONFIG.paths[:assets] / "icons").generate_sprites
  puts "🐱 Generated spritesheets"

  # Move static files to /assets/
  puts "🐱 Moving static files"
  Dir.each_child(GeopJr::CONFIG.paths[:static]) do |static_sub|
    next if static_sub.starts_with?("_")
    FileUtils.cp_r(GeopJr::CONFIG.paths[:static] / static_sub, GeopJr::CONFIG.paths[:out])
  end
  puts "🐱 Moved static files"

  {% unless flag?(:novips) %}
    # OpenGraph covers
    puts "🐱 Generating OpenGraph covers"
    (GeopJr::OGCovers.new).generate
    puts "🐱 Generated OpenGraph covers"
  {% end %}

  # sitemap.xml
  puts "🐱 Generating sitemap"
  File.write(GeopJr::CONFIG.paths[:out] / "sitemap.xml", SitemapXML.new.to_s)
  puts "🐱 Generated sitemap"

  # rss.xml
  puts "🐱 Generating RSS"
  RSSXML.generate(GeopJr::CONFIG.paths[:out] / "rss.xml")
  puts "🐱 Generated RSS"

  # Delete underscore files
  puts "🐱 Removing unnecessary files"
  FileUtils.rm_rf(Dir.glob(GeopJr::CONFIG.paths[:out] / "**" / "*").select { |x| File.basename(x).starts_with?("_") })
  puts "🐱 Removed unnecessary files"

  puts "🐱 Running tools"
  GeopJr::Tools.new(should_sass, should_minify, should_zip)
  puts "🐱 Ran tools"
end

GeopJr::Server.serve if should_serve
