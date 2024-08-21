require_relative 'touch_screen_z41_dsl.rb'

class TouchScreenZ41Lite < TouchScreenZ41
    def initialize
        super
        @inputs = 2
    end
end