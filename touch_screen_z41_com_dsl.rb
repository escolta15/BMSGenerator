require_relative 'touch_screen_z41_dsl.rb'

class TouchScreenZ41Com < TouchScreenZ41
    def initialize
        super
        @sound = ['Microphone', 'Speakers']
        @ports << 'Ethernet'
    end
end