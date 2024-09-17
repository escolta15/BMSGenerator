require_relative 'angular_project_dsl.rb'

class AngularProjectDSLParent < AngularProjectDSL

  def initialize(app_name)
    super(app_name)
    @type = "parent"
  end

  def generate
    create_project(@project_name)
    Dir.chdir(@project_name) do
      install_packages()
      
      files = Dir.glob(File.join("../templates/#{@type}/", '*'))
      read_templates(files, '', binding)

      add_script_in_package_json
    end
  end

  private

  def add_script_in_package_json
    file_path = 'package.json'
    file_content = File.read(file_path)
    data = JSON.parse(file_content)
    data["scripts"]["start:all"] = "node start_apps.js"
    File.open(file_path, 'w') do |file|
      file.write(JSON.pretty_generate(data))
    end
  end

  def generate_project
    system("ng new #{@project_name} --create-application=false")
  end

end
