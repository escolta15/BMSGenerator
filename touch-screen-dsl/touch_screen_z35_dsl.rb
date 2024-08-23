require_relative 'touch_screen_dsl.rb'

class TouchScreenZ35 < TouchScreen
  attr_accessor :iluminated_button

  def initialize
      super
      @size = "3.5\""
      @width = "320px"
      @height = "240px"
      @lcd = false
      @pages = 7
      @sensors = ['Proximity', 'Light', 'Temperature', 'Humidity']
      @thermostats = 2
      @inputs = 4
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