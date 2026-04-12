require "vips"

module Vips
  class Image
    def self.text(text : String, **kwargs)
      options = Optional.new(**kwargs)

      Vips::Operation.call("text", options, text).as(Type).as_image
    end
  end
end

class GeopJr::OGCovers
  BOTTOM_BEGIN_PX    = 520
  TOP_UNSAFE_ZONE_PX = 107

  @im : Vips::Image

  def initialize
    @im = Vips::Image.new_from_file(
      (GeopJr::CONFIG.paths[:static] / "assets" / "images" / "opengraph" / "_template.webp").to_s,
      access: Vips::Enums::Access::Sequential
    )
  end

  private def calculate_center(base_size : Int, layer_size : Int) : Int
    ((base_size / 2) - (layer_size / 2)).clamp(0, (base_size - layer_size).clamp(nil, base_size)).to_i
  end

  private def generate_og_image(out_path : String, title : String, subtitle : String? = nil)
    title_im = Vips::Image.text(
      "<span foreground=\"white\">#{HTML.escape(title)}</span>",
      width: 980,
      font: "Instrument Serif 105",
      fontfile: (GeopJr::CONFIG.paths[:static] / "assets" / "fonts" / "instrument-serif" / "instrument-serif-latin.woff2").to_s,
      rgba: true,
      spacing: -10,
      align: 1 # center
    )

    final_im = @im.composite(
      title_im,
      Vips::Enums::BlendMode::Over,
      x: calculate_center(@im.width, title_im.width),
      y: calculate_center(BOTTOM_BEGIN_PX - TOP_UNSAFE_ZONE_PX, title_im.height) + TOP_UNSAFE_ZONE_PX
    )

    if !(sub = subtitle).nil? && sub != ""
      sub_im = Vips::Image.text(
        "<span background=\"blue\" foreground=\"blue\">_</span><span background=\"blue\" foreground=\"white\">#{HTML.escape(sub)}</span><span background=\"blue\" foreground=\"blue\">_</span>",
        width: 980,
        font: "Adwaita Mono 40",
        fontfile: (GeopJr::CONFIG.paths[:static] / "assets" / "fonts" / "adwaita-mono" / "adwaita-mono-bold-latin.woff2").to_s,
        rgba: true,
        spacing: -10,
        align: 1 # center
      )

      final_im = final_im.composite(
        sub_im,
        Vips::Enums::BlendMode::Over,
        x: calculate_center(@im.width, sub_im.width),
        y: BOTTOM_BEGIN_PX + calculate_center(
          @im.height - BOTTOM_BEGIN_PX,
          sub_im.height
        )
      )
    end

    final_im.write_to_file(out_path)
  end

  def generate
    BLOG_POSTS.each do |v|
      out_path = GeopJr::CONFIG.paths[:out] / "assets" / "images" / "opengraph" / "#{v.filename}.png"
      next if File.exists?(out_path)
      generate_og_image(out_path.to_s, v.fm.title, v.fm.subtitle)
    end
  end
end
