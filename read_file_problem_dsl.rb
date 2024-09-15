require 'erb'
require 'json'
require 'fileutils'
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

module TouchScreenType
  Z100 = 'z100'
  Z70 = 'z70'
  Z50 = 'z50'
  Z41COM = 'z41Com'
  Z41PRO = 'z41Pro'
  Z41LITE = 'z41Lite'
  Z40 = 'z40'
  Z35 = 'z35'
  Z28 = 'z28'
end

file_path = 'demo_example.json'
json_data = File.read(file_path)
parsed_data = JSON.parse(json_data)

def read_touchscreens(workspace_name, touchscreens)
  touchscreens.each do |touchscreen|

    touchscreen_type = touchscreen['type']
    current_touchscreen = nil
    current_project = nil
    case touchscreen_type
    when TouchScreenType::Z100
      current_touchscreen = TouchScreenZ100.new
    when TouchScreenType::Z70
      current_touchscreen = TouchScreenZ70.new
    when TouchScreenType::Z50
      current_touchscreen = TouchScreenZ50.new
    when TouchScreenType::Z41COM
      current_touchscreen = TouchScreenZ41Com.new
    when TouchScreenType::Z41PRO
      current_touchscreen = TouchScreenZ41Pro.new
    when TouchScreenType::Z41LITE
      current_touchscreen = TouchScreenZ41Lite.new
    when TouchScreenType::Z40
      current_touchscreen = TouchScreenZ40.new
    when TouchScreenType::Z35
      current_touchscreen = TouchScreenZ35.new
    when TouchScreenType::Z28
      current_touchscreen = TouchScreenZ28.new
    else
      puts "That touchscreen (#{touchscreen['name']}) does not exist."
    end
    if !current_touchscreen.nil?
      current_touchscreen.name = touchscreen['name'].gsub(" ", "")
      current_touchscreen.set_color(touchscreen['color'])
      if touchscreen['licenses'] && !touchscreen['licenses'].empty?
        touchscreen['licenses'].each do |license|
          current_touchscreen.set_license(license)
        end
      end

      current_project = AngularProjectDSLRemote.new(current_touchscreen.name, workspace_name, current_touchscreen)
      current_project.component("Page")
      current_project.component("Box")
      current_project.generate
    end
  end
end

if parsed_data['projectName'] && !parsed_data['projectName'].empty?
  workspace_name = "BMS-" + parsed_data['projectName'].gsub(" ", "_")
  puts "The name is #{workspace_name}"

  project = AngularProjectDSLParent.new(workspace_name)
  project.package('@angular-architects/native-federation', '17.1.8', true)
  project.package('concurrently', '8.2.2', true)
  project.package('@angular/material', '17.3.10', false)
  project.generate

  project = AngularProjectDSLHost.new('home', workspace_name)
  project.component("NotFound")
  project.component("Home")
  project.generate
  
  if parsed_data['touchscreens'] && !parsed_data['touchscreens'].empty?
    read_touchscreens(workspace_name, parsed_data['touchscreens'])
  else
    puts "There are not any touchscreen to add."
  end
else
  puts "The name for the project is empty or it does not exist."
end