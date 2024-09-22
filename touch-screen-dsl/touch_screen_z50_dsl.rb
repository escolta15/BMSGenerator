require_relative 'touch_screen_dsl.rb'

class TouchScreenZ50 < TouchScreen
    def initialize
        super
        @name = "z50"
        @size = "5\""
        @width = "480px"
        @height = "854px"
        @lcd = true
        @pages = 12
        @sensors = ['Proximity', 'Light', 'Temperature']
        @thermostats = 2
        @inputs = 2
        @sound = ['Microphone', 'Speakers']
        @ports << 'Ethernet'
        @ports << 'Micro-USB'
        @licenses = []
    end

    def set_color(color)
      super(color)
      if (color == 'glossy white')
        @color = "#ECECE8"
      end
    end

    def set_license(name)
      @licenses << name
    end

    def get_licenses
      @licenses
    end
end