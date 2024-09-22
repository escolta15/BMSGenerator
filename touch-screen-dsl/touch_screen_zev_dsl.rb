require_relative 'touch_screen_dsl.rb'

class TouchScreenZEV < TouchScreen
    def initialize
        super
        @name = "zev"
        @size = "5.5\""
        @width = "480px"
        @height = "854px"
        @lcd = true
        @pages = 7
        @sensors = ['Proximity']
        @thermostats = 2
        @inputs = 2
        @licenses = []
    end

    def set_color(color)
      super(color)
      if (color == 'glossy white')
        @color = "#ECECE8"
      elsif (color == 'blue light')
        @color = "#ADD8E6"
      end
    end

    def set_license(name)
      @licenses << name
    end

    def get_licenses
      @licenses
    end
end