require "http/server"

module GeopJr::Server
  PORT = 1312

  def self.serve
    GeopJr::CONFIG.paths[:out]

    server = HTTP::Server.new({
      HTTP::ErrorHandler.new,
      HTTP::LogHandler.new,
      HTTP::CompressHandler.new,
      HTTP::StaticFileHandler.new(GeopJr::CONFIG.paths[:out].to_s, true, false),
    }) do |context|
      if context.request.method == "GET"
        filename = nil

        if context.request.path == "/"
          filename = GeopJr::CONFIG.paths[:out] / "index.html"
        elsif context.request.path.ends_with?('/')
          filename = GeopJr::CONFIG.paths[:out] / "#{context.request.path[1..-2]}.html"
        elsif !context.request.path.includes?('.')
          filename = GeopJr::CONFIG.paths[:out] / "#{context.request.path[1..]}.html"
        end

        if !filename.nil? && File.exists?(filename)
          context.response.content_type = "text/html"

          File.open(filename) do |file|
            IO.copy(file, context.response)
          end
        end
      end
    end

    puts "🐱 http://localhost:#{PORT}"
    server.listen(PORT)
    exit(0)
  end
end
