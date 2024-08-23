require_relative 'touch_screen_dsl.rb'

class TouchScreenZ40 < TouchScreen
  attr_accessor :iluminated_button

  def initialize
      super
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
end