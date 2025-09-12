require "http/client"
require "compress/gzip"
require "compress/zip"
require "process"
require "crystar"

class GeopJr::Tools
  SASS_VERSION   = "1.92.1"
  SASS_PATH      = GeopJr::CONFIG.paths[:tools] / "dart-sass" / "sass"
  SASS_OUT       = GeopJr::CONFIG.paths[:out] / "assets" / "css"
  MINIFY_VERSION = "v2.24.3"
  MINIFY_PATH    = GeopJr::CONFIG.paths[:tools] / "minify" / "minify"

  getter has_sass : Bool = false
  getter has_minify : Bool = false

  def initialize(@sass : Bool, @minify : Bool, @zip : Bool, @watch_sass : Bool = false)
    return unless @sass || @minify || @zip

    Dir.mkdir(GeopJr::CONFIG.paths[:tools]) unless Dir.exists?(GeopJr::CONFIG.paths[:tools])
    @has_sass = install_sass() if @sass
    @has_minify = install_minify() if @minify

    # No need to not do them in construct
    sass()
    minify()
    zip() if @zip
  end

  def minify
    return unless @has_minify

    puts "🐱 Running minify"
    Process.run(
      MINIFY_PATH.to_s,
      args: ["-r", "-i", GeopJr::CONFIG.paths[:out].to_s],
      output: Process::Redirect::Inherit, error: Process::Redirect::Inherit
    )
    puts "🐱 Ran minify"
  end

  def sass
    return unless @has_sass

    args = ["#{__DIR__}/scss/:#{SASS_OUT}", "--no-source-map", "--style", "compressed"]
    args << "--watch" if @watch_sass

    puts "🐱 Running dart-sass"
    Process.run(
      SASS_PATH.to_s,
      args: args,
      output: Process::Redirect::Inherit, error: Process::Redirect::Inherit
    )
    puts "🐱 Ran dart-sass"
  end

  private def download(download_link : String, redirected = false, &block : HTTP::Client::Response ->)
    HTTP::Client.get(download_link) do |response|
      if response.status.success?
        yield response
      elsif !response.status.redirection?
        STDERR.puts "🐱 Couldn't download #{download_link}: #{response.status_code}"
      elsif !redirected
        download(response.headers["location"], true, &block)
      else
        STDERR.puts "🐱 Couldn't download #{download_link}: too many redirections}"
      end
    end
  end

  private def extract_tar_gz(path : Path, &block : Crystar::Header ->)
    puts "🐱 Extracting #{path.basename}"
    File.open(path) do |file|
      Compress::Gzip::Reader.open(file) do |gzip|
        Crystar::Reader.open(gzip) do |tar|
          tar.each_entry do |entry|
            yield entry
          end
        end
      end
    end
    puts "🐱 Extracted #{path.basename}"
  end

  private def write_file(io : IO, path : Path | String)
    File.open(path, "w") do |file|
      IO.copy(io, file)
    end
  end

  private def install_sass : Bool
    return true if Dir.exists?(GeopJr::CONFIG.paths[:tools] / "dart-sass")
    path = GeopJr::CONFIG.paths[:tools] / "sass.tar.gz"

    unless File.exists?(path)
      puts "🐱 Downloading dart-sass"
      download("https://github.com/sass/dart-sass/releases/download/#{SASS_VERSION}/dart-sass-#{SASS_VERSION}-linux-x64.tar.gz") do |response|
        write_file(response.body_io, path)
      end
      puts "🐱 Downloaded dart-sass"
    end

    extract_tar_gz(path) do |entry|
      entry_path = GeopJr::CONFIG.paths[:tools] / entry.name
      Dir.mkdir_p(entry_path.parent)

      write_file(entry.io, entry_path)
      File.chmod(entry_path, File::Permissions::OwnerAll) if {"dart", "sass", "sass.snapshot"}.includes? entry_path.basename
    end

    File.delete(path)
    true
  end

  private def install_minify : Bool
    return true if Dir.exists?(GeopJr::CONFIG.paths[:tools] / "minify")
    path = GeopJr::CONFIG.paths[:tools] / "minify.tar.gz"

    unless File.exists?(path)
      puts "🐱 Downloading minify"
      download("https://github.com/tdewolff/minify/releases/download/#{MINIFY_VERSION}/minify_linux_amd64.tar.gz") do |response|
        write_file(response.body_io, path)
      end
      puts "🐱 Finished downloading minify"
    end

    extract_tar_gz(path) do |entry|
      entry_path = GeopJr::CONFIG.paths[:tools] / "minify" / entry.name
      Dir.mkdir_p(entry_path.parent)

      write_file(entry.io, entry_path)
      File.chmod(entry_path, File::Permissions::OwnerAll) if entry_path.basename == "minify"
    end

    File.delete(path)
    true
  end

  private def zip
    return unless Dir.exists?(GeopJr::CONFIG.paths[:out])

    zipfile = Path[GeopJr::CONFIG.paths[:out].parent / "#{GeopJr::CONFIG.paths[:out].stem}.zip"]
    File.delete(zipfile) if File.exists?(zipfile)

    puts "🐱 Zipping #{zipfile}"
    File.open(zipfile, "w") do |file|
      Compress::Zip::Writer.open(file) do |zip|
        Dir.glob("#{GeopJr::CONFIG.paths[:out]}/**/*", match: File::MatchOptions::DotFiles).each do |entry|
          if File.directory?(entry)
            zip.add_dir(Path[entry].relative_to(GeopJr::CONFIG.paths[:out]).to_s)
          elsif File.file?(entry)
            zip.add(Path[entry].relative_to(GeopJr::CONFIG.paths[:out]).to_s, File.open(entry))
          end
        end
      end
    end
    puts "🐱 Zipped #{zipfile}"
  end
end
