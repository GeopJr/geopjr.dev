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
end
