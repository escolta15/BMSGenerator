require 'test/unit'
require_relative 'angular-project-dsl/angular_project_dsl.rb'
require_relative 'angular-project-dsl/angular_project_dsl_parent.rb'
require_relative 'angular-project-dsl/angular_project_dsl_host.rb'
require_relative 'angular-project-dsl/angular_project_dsl_remote.rb'
require_relative 'touch-screen-dsl/touch_screen_dsl.rb'
require_relative 'touch-screen-dsl/touch_screen_z100_dsl.rb'
require_relative 'touch-screen-dsl/touch_screen_z70_dsl.rb'
require_relative 'touch-screen-dsl/touch_screen_z50_dsl.rb'
require_relative 'touch-screen-dsl/touch_screen_z41_dsl.rb'
require_relative 'touch-screen-dsl/touch_screen_z41_com_dsl.rb'
require_relative 'touch-screen-dsl/touch_screen_z41_pro_dsl.rb'
require_relative 'touch-screen-dsl/touch_screen_z41_lite_dsl.rb'
require_relative 'touch-screen-dsl/touch_screen_z40_dsl.rb'
require_relative 'touch-screen-dsl/touch_screen_z35_dsl.rb'
require_relative 'touch-screen-dsl/touch_screen_z28_dsl.rb'

class TestTouchScreens < Test::Unit::TestCase
  def test_valid_z100_color
    z100 = TouchScreenZ100.new
    z100.set_color('silver')
    assert_equal('#a1a1a0', z100.get_color)
    z100.set_color('glossy white')
    assert_equal('#ECECE8', z100.get_color)
  end
  def test_invalid_z100_color
    z100 = TouchScreenZ100.new
    z100.set_color('red')
    assert_equal('', z100.get_color)
  end
  def test_valid_z28_color
    z100 = TouchScreenZ100.new
    z100.set_color('silver')
    assert_equal('#a1a1a0', z100.get_color)
  end
end