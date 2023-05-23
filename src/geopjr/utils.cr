# Random utilities
module GeopJr::Utils
  extend self

  # Darkens *hex_color*
  def darken(hex_color : String, ratio : Float32 = 0.4) : String
    hsl = Cor.new(hex_color).to_hsl
    lightness = hsl[:l] - (hsl[:l] * ratio)
    res = Cor.from_hsl(hsl[:h], hsl[:s], lightness).hex_string
    "##{res}"
  end

  def prepare_output_dir
    FileUtils.rm_rf(GeopJr::CONFIG.paths[:out]) if Dir.exists?(GeopJr::CONFIG.paths[:out])
    Dir.mkdir(GeopJr::CONFIG.paths[:out])
    Dir.mkdir(GeopJr::CONFIG.paths[:out] / GeopJr::CONFIG.blog_out_path)
  end
end
