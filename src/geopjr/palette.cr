module GeopJr
  class Palette
    Colors = {
      blue: {
        light:           "#0461be",
        dark:            "#3584e4",
        dark_standalone: "#81d0ff",
      },
      teal: {
        light:           "#007184",
        dark:            "#2190a4",
        dark_standalone: "#7bdff4",
      },
      green: {
        light:           "#15772e",
        dark:            "#3a944a",
        dark_standalone: "#8de698",
      },
      yellow: {
        light:           "#905300",
        dark:            "#c88800",
        dark_standalone: "#ffc057",
      },
      orange: {
        light:           "#b62200",
        dark:            "#ed5b00",
        dark_standalone: "#ff9c5b",
      },
      red: {
        light:           "#c00023",
        dark:            "#e62d42",
        dark_standalone: "#ff888c",
      },
      pink: {
        light:           "#a2326c",
        dark:            "#d56199",
        dark_standalone: "#ffa0d8",
      },
      purple: {
        light:           "#8939a4",
        dark:            "#9141ac",
        dark_standalone: "#fba7ff",
      },
      slate: {
        light:           "#526678",
        dark:            "#6f8396",
        dark_standalone: "#bbd1e5",
      },
      brown: {
        light:           "#7c5c36",
        dark:            "#b39169",
        dark_standalone: "#ebc79d",
      },
    }

    SHUFFLED_KEYS = Colors.keys.to_static_array.shuffle!

    @current_color_key : Symbol

    def initialize
      @current_color_key = SHUFFLED_KEYS.sample
    end

    def next
      keys = SHUFFLED_KEYS
      next_index = keys.index!(@current_color_key) + 1
      @current_color_key = keys[next_index % keys.size]
    end

    def current_color
      Colors[@current_color_key]
    end

    def to_dither(dark : Bool)
      Palette.to_dither(@current_color_key, dark)
    end

    def self.to_dither(color_key : Symbol, dark : Bool = false)
      "/assets/images/dither/#{dark ? "d" : "l"}-#{color_key}.webp"
    end

    def color_to_sass
      Palette.color_to_sass(@current_color_key)
    end

    def self.color_to_sass(color_key : Symbol)
      color = Colors[color_key]
      <<-SASS
      :root[theme='#{color_key}'] {
        --accent: #{color[:light]};
        --dither-image: url(#{to_dither(color_key, false)});
      }

      @media (prefers-color-scheme: dark) {
        :root[theme='#{color_key}'] {
          --accent: #{color[:dark]};
          --accent-color: #{color[:dark_standalone]};
          --dither-image: url(#{to_dither(color_key, true)});
        }
      }

      SASS
    end

    def self.to_sass
      String.build do |s|
        s << "// file managed by crystal, do not modify\n"
        Colors.keys.each do |k|
          s << color_to_sass(k)
        end
      end
    end
  end

  File.write(Path[__DIR__, "..", "scss", "_cc.scss"], Palette.to_sass)
end
