require_relative 'touch_screen_dsl.rb'

class TouchScreenZ28 < TouchScreen
  attr_accessor :iluminated_button

  def initialize
      super
      @name = "z28"
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
end