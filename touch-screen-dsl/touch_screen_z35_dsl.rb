require_relative 'touch_screen_dsl.rb'

class TouchScreenZ35 < TouchScreen
  attr_accessor :iluminated_button

  def initialize
      super
      @name = "z35"
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
end