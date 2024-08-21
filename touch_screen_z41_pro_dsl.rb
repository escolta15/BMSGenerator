require_relative 'touch_screen_z41_dsl.rb'

class TouchScreenZ41Pro < TouchScreenZ41
    def initialize
        super
        @inputs = 2
        @ports << 'Ethernet'
        @battery = true
    end
end