require 'erb'
require 'json'
require 'tty-prompt'
require 'fileutils'

prompt = TTY::Prompt.new

def to_lower_kebab_case(text)
  text
    .strip
    .gsub(/\s+/, '-')
    .gsub(/([a-z])([A-Z])/, '\1-\2')
    .downcase
end

def empty_json_file(file_path)
  empty_json = {}.to_json
  File.open(file_path, 'w') do |file|
    file.write(empty_json)
  end
end

def add_remote_entry(app_name, port)
  file_path = 'projects/home/src/assets/federation.manifest.json'
  file_content = File.read(file_path)
  data = JSON.parse(file_content)
  data[app_name] = "http://localhost:#{port}/remoteEntry.json"
  File.open(file_path, 'w') do |file|
    file.write(JSON.pretty_generate(data))
  end
end

def add_route(app_name)
  file_path = 'projects/home/src/app/app.routes.ts'
  content = File.read(file_path)
  regex = /(\[\s*)([^\]]*)(\s*\])/
  new_line = "" 
  new_content = content.gsub(regex) do |match|
    opening_bracket = $1
    array_content = $2.strip
    closing_bracket = $3
    new_content = "{\n\tpath: '#{app_name}',\n\tloadComponent: () => loadRemoteModule('#{app_name}', './Component').then((m) => m.AppComponent) }"
    if array_content.empty?
      new_line = "import { loadRemoteModule } from '@angular-architects/native-federation';\n"
      "#{opening_bracket}#{new_content}#{closing_bracket}"
    else  
      "#{opening_bracket}#{array_content}, #{new_content}#{closing_bracket}"
    end
  end
  File.open(file_path, 'w') do |file|
    file.write(new_line + new_content)
  end
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

options = ["Z40", "Z41"]
selection = prompt.select("Select an option please:", options)
puts "#{selection}"

name = ""

while name == ""
  puts "Please, insert a name for the #{selection}:"
  name = gets.chomp
end
project_name = to_lower_kebab_case(name)
puts "The name is #{project_name}"
if !Dir.exist?("projects/#{project_name}")
  system("npm i @angular-architects/native-federation@17 -D")
  system("npm i npm i concurrently -D")
  system("ng generate application home --ssr=false --routing --style=scss --skip-install=true")
  system("ng g @angular-architects/native-federation:init --project home --port 4200 --type dynamic-host")
  empty_json_file('projects/home/src/assets/federation.manifest.json')
  add_start_command('home')
  system("ng generate application #{project_name} --ssr=false --routing --style=scss --skip-install=true")
  system("ng g @angular-architects/native-federation:init --project #{project_name} --port 4201 --type remote")
  add_remote_entry(project_name, 4201)
  add_route(project_name)
  add_start_command(project_name)
  system("ng generate application #{project_name}1 --ssr=false --routing --style=scss --skip-install=true")
  system("ng g @angular-architects/native-federation:init --project #{project_name}1 --port 4202 --type remote")
  add_remote_entry(project_name + '1', 4202)
  add_route(project_name + '1')
  add_start_command(project_name + '1')
else
  puts("The workspace #{project_name} exists. It will not be created again.")
end

