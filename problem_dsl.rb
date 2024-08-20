require 'erb'
require 'tty-prompt'

prompt = TTY::Prompt.new

puts "Please, insert a name for the building:"
name = gets.chomp
workspace_name = "BMS-" + name.gsub(" ", "_")
puts "The name is #{workspace_name}"
if !Dir.exist?(workspace_name)
  system("ng new #{workspace_name} --create-application=false")
else
  puts("The workspace #{workspace_name} exists. It will not be created again.")
end
Dir.chdir(workspace_name)

options = ["Z40", "Z41"]
selection = prompt.select("Select an option please:", options)
puts "#{selection}"

puts "Please, insert a name for the #{selection}:"
project_name = gets.chomp
puts "The name is #{project_name}"
if !Dir.exist?("projects/#{project_name}")
  system("ng generate application #{project_name} --ssr=false --routing --style=scss")
else
  puts("The workspace #{project_name} exists. It will not be created again.")
end

