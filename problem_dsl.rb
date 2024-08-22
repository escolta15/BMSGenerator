require 'erb'
require 'json'
#require 'tty-prompt'
require 'fileutils'
require_relative 'angular_project_dsl.rb'
require_relative 'angular_project_dsl_parent.rb'
require_relative 'angular_project_dsl_host.rb'
require_relative 'angular_project_dsl_remote.rb'
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

#prompt = TTY::Prompt.new

#def to_lower_kebab_case(text)
#  text
#    .strip
#    .gsub(/\s+/, '-')
#    .gsub(/([a-z])([A-Z])/, '\1-\2')
#    .downcase
#end

#def add_file(origin_file, destination_file)
#  FileUtils.cp(origin_file, destination_file)
#end

name = ""

while name == ""
  puts "Please, insert a name for the building:"
  name = gets.chomp
end
workspace_name = "BMS-" + name.gsub(" ", "_")
puts "The name is #{workspace_name}"

project = AngularProjectDSLParent.new(workspace_name)
project.package('@angular-architects/native-federation', '17.1.8', true)
project.package('concurrently', '8.2.2', true)
project.package('@angular/material', '17.3.10', false)
project.generate

#options = ["Z40", "Z41"]
#selection = prompt.select("Select an option please:", options)
#puts "#{selection}"

#name = ""

#while name == ""
#  puts "Please, insert a name for the #{selection}:"
#  name = gets.chomp
#end
#project_name = to_lower_kebab_case(name)
#puts "The name is #{project_name}"

project = AngularProjectDSLHost.new('home', workspace_name)
project.component("NotFound")
project.component("Home")
project.generate

z100 = TouchScreenZ100.new
z100.name = 'z100'
z100.set_color('silver')
z100.set_license('Smartphone Control')

z50 = TouchScreenZ50.new
z50.name = 'z50'
z50.set_color('matte white')

touch_screens = [z100, z50]

for touch_screen in touch_screens
  project = AngularProjectDSLRemote.new(touch_screen.name, workspace_name, touch_screen)
  project.component("Page")
  project.component("Box")
  project.generate
end