require_relative 'touch_screen_dsl.rb'

class TouchScreenZ50 < TouchScreen
    def initialize
        super
        @size = "5\""
        @width = "480px"
        @height = "854px"
        @lcd = true
        @pages = 12
        @sensors = ['Proximity', 'Light', 'Temperature']
        @thermostats = 2
        @inputs = 2
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