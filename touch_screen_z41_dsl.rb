require_relative 'touch_screen_dsl.rb'

class TouchScreenZ41 < TouchScreen
    attr_accessor :magnet

    def initialize
        super
        @size = "4.1\""
        @width = "320px"
        @height = "240px"
        @lcd = true
        @pages = 12
        @sensors = ['Temperature']
        @thermostats = 2
        @ports << 'Micro-USB'
        @magnet = true
    end
end