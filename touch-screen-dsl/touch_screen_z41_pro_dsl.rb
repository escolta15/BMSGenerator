class TouchScreenZ41Pro < TouchScreenZ41
    def initialize
        super
        @name = "z41PRO"
        @inputs = 2
        @ports << 'Ethernet'
        @battery = true
    end
end