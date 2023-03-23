module GeopJr
  class Icons
    def initialize(@icons_path : Path, @output_path : Path)
      Dir.mkdir_p(@output_path)
    end

    def generate_sprites
      Dir.each_child(@icons_path) do |icon|
        icon_path = @icons_path / icon
        next if Dir.exists?(icon_path)
        next File.copy(icon_path, @output_path / icon.byte_slice(1)) if icon.starts_with?('_')

        id = icon_path.basename(".svg")
        svg = File.read(icon_path)
        defs = svg.match(/<defs>.+<\/defs>/).try &.[0]
        svg.sub(defs, "") if !defs.nil?
        sprite = <<-SVG
        <svg width="0" height="0" class="hidden" #{defs.nil? ? nil : "xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\""}>#{defs}#{svg.sub(/width="[0-9]+"/, "").sub(/height="[0-9]+"/, "").sub(/viewBox="[0-9]+ [0-9]+ [0-9]+ [0-9]+"/, "").sub("<svg ", "<symbol id=\"#{id}\" viewBox=\"0 0 24 24\" ").sub("</svg>", "</symbol>")}</svg>
        SVG
        File.write(@output_path / icon, sprite)
      end
    end
  end
end
