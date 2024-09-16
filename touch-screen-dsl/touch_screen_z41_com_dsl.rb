class TouchScreenZ41Com < TouchScreenZ41
    def initialize
        super
        @name = "z41COM"
        @sound = ['Microphone', 'Speakers']
        @ports << 'Ethernet'
    end
end