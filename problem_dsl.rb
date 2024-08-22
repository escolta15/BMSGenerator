require 'erb'
require 'json'
require 'tty-prompt'
require 'fileutils'
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

prompt = TTY::Prompt.new

def to_lower_kebab_case(text)
  text
    .strip
    .gsub(/\s+/, '-')
    .gsub(/([a-z])([A-Z])/, '\1-\2')
    .downcase
end

def add_start_command(app_name)
  file_path = 'start_apps.js'
  content = File.read(file_path)
  regex = /(\[\s*)([^\]]*)(\s*\])/
  new_content = content.gsub(regex) do |match|
    opening_bracket = $1
    array_content = $2.strip
    closing_bracket = $3
    new_content = "\n\t\"\\\"ng serve #{app_name}\\\"\""
    if array_content.empty?
      "#{opening_bracket}#{new_content}#{closing_bracket}"
    else  
      "#{opening_bracket}#{array_content}, #{new_content}#{closing_bracket}"
    end
  end
  File.open(file_path, 'w') do |file|
    file.write(new_content)
  end
end

def add_file(origin_file, destination_file)
  FileUtils.cp(origin_file, destination_file)
end

def add_script_in_package_json
  file_path = 'package.json'
  file_content = File.read(file_path)
  data = JSON.parse(file_content)
  data["scripts"]["start:all"] = "node start_apps.js"
  File.open(file_path, 'w') do |file|
    file.write(JSON.pretty_generate(data))
  end
end

name = ""

while name == ""
  puts "Please, insert a name for the building:"
  name = gets.chomp
end
workspace_name = "BMS-" + name.gsub(" ", "_")
puts "The name is #{workspace_name}"
if !Dir.exist?(workspace_name)
  system("ng new #{workspace_name} --create-application=false")
  add_file("templates/template_start_apps.js", "#{workspace_name}/start_apps.js")
else
  puts("The workspace #{workspace_name} exists. It will not be created again.")
end
Dir.chdir(workspace_name)
add_script_in_package_json
system("npm i @angular-architects/native-federation@17 -D")
system("npm i npm i concurrently -D")

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

z100 = TouchScreenZ100.new
z100.name = 'z100'
z100.set_color('silver')
z100.set_license('Smartphone Control')

touch_screens = [z100]

#el puerto hacerlo con el indice
project = AngularProjectDSL.new('home', 4200, 'dynamic-host')
project.generate

for touch_screen in touch_screens
  project = AngularProjectDSL.new(touch_screen.name, 4201, 'remote', touch_screen)
  project.package('@angular/material', '17.3.10')
  project.component("Page")
  project.component("Box")
  project.generate
end