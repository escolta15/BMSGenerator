require_relative 'touch_screen_dsl.rb'

class TouchScreenZ40 < TouchScreen
  attr_accessor :iluminated_button

  def initialize
      super
      @name = "z40"
      @size = "4\""
      @width = "320px"
      @height = "240px"
      @lcd = false
      @pages = 7
      @sensors = ['Proximity', 'Light', 'Temperature']
      @thermostats = 2
      @inputs = 4
      @iluminated_button = true
  end

  def set_color(color)
    super(color)
    if (color == 'glossy white')
      @color = "#ECECE8"
    end
  end
      
end