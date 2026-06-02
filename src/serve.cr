require "http/server"
require "http/web_socket"

module GeopJr::Server
  PORT = 1312

  alias PathEntry = String | Tuple(String, Bool)
  @@sockets = [] of HTTP::WebSocket

  class WSMessage
    include JSON::Serializable

    class WSPath
      include JSON::Serializable

      def initialize(entry : PathEntry)
        case entry
        in String
          @path = entry
          @full = false
        in Tuple(String, Bool)
          @path = entry[0]
          @full = entry[1]
        end
      end

      property path : String
      property full : Bool
    end

    def initialize(@command)
    end

    property command : String
    property paths : Array(WSPath)?
  end

  def self.request_reload(paths : PathEntry | Array(PathEntry)? = nil)
    msg = WSMessage.new("reload")

    case paths
    in PathEntry
      msg.paths = [WSMessage::WSPath.new(paths)]
    in Array(Tuple(String, Bool)), Array(String), Array(String | Tuple(String, Bool))
      final_paths = [] of WSMessage::WSPath

      paths.each do |path|
        final_paths << WSMessage::WSPath.new(path)
      end

      msg.paths = final_paths
    in nil
    end

    @@sockets.each &.send(msg.to_json)
  end

  def self.serve
    GeopJr::CONFIG.paths[:out]

    server = HTTP::Server.new({
      HTTP::ErrorHandler.new,
      HTTP::LogHandler.new,
      HTTP::CompressHandler.new,
      HTTP::StaticFileHandler.new(GeopJr::CONFIG.paths[:out].to_s, true, false),
      HTTP::WebSocketHandler.new do |socket|
        @@sockets.push socket.tap(&.on_close { @@sockets.delete(socket) })
      end,
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
