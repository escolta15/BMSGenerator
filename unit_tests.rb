require 'test/unit'
require_relative 'angular_project_dsl.rb'
require_relative 'touch_screen_dsl.rb'
require_relative 'touch_screen_z100_dsl.rb'
require_relative 'touch_screen_z70_dsl.rb'
require_relative 'touch_screen_z50_dsl.rb'
require_relative 'touch_screen_z41_com_dsl.rb'
require_relative 'touch_screen_z41_pro_dsl.rb'
require_relative 'touch_screen_z41_lite_dsl.rb'
require_relative 'touch_screen_z40_dsl.rb'
require_relative 'touch_screen_z35_dsl.rb'
require_relative 'touch_screen_z28_dsl.rb'

class TestTouchScreens < Test::Unit::TestCase
  def test_z100_color
    z100 = TouchScreenZ100.new
    z100.set_color('silver')
    assert_equal('#a1a1a0', z100.get_color)
  end
end