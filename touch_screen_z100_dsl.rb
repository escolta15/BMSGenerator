require_relative 'touch_screen_dsl.rb'

class TouchScreenZ100 < TouchScreen
    def initialize
        super
        @size = "10\""
        @width = "1280px"
        @height = "800px"
        @lcd = true
        @pages = 12
        @sensors = ['Proximity', 'Light', 'Temperature']
        @thermostats = 2
        @inputs = 4
        @sound = ['Microphone', 'Speakers']
        @ports << ['Ethernet', 'Micro-USB']
        @licenses = []
    end

    def set_license(name)
      @licenses << name
    end

    def get_licenses
      @licenses
    end
end