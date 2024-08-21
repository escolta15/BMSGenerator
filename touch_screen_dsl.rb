class TouchScreen
  attr_accessor :name, :width, :height, :lcd, :pages, :sensors, :thermostats, :inputs, :sound, :clock, :programming, :ports

  def initialize
    @external_power_supply = true
    @clock = true
    @programming = true
    @ports = ['KNX']
  end

  def set_color(color)
    if (color == 'silver')
        @color = "#a1a1a0"
    elsif (color == 'anthracite black')
        @color = "#2A2A2C"
    elsif (color == 'matte white')
        @color = "#F0EFE9"
    elsif (color == 'glossy white')
        @color = "#ECECE8"
    end
  end

  def get_color
    @color
  end

end