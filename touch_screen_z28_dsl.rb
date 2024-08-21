require_relative 'touch_screen_dsl.rb'

class TouchScreenZ28 < TouchScreen
  attr_accessor :iluminated_button

  def initialize
      super
      @size = "2.8\""
      @width = "240px"
      @height = "320px"
      @lcd = false
      @pages = 5
      @sensors = ['Proximity', 'Light']
      @thermostats = 2
      @inputs = 2
      @iluminated_button = true
  end

  def set_color(color)
    if (color == 'silver')
        @color = "#a1a1a0"
    elsif (color == 'anthracite black')
        @color = "#2A2A2C"
    elsif (color == 'matte white')
        @color = "#F0EFE9"
    end
  end
end