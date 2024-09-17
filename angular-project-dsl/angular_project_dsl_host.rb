require_relative 'angular_project_dsl.rb'

class AngularProjectDSLHost < AngularProjectDSL
  attr_accessor :port, :workspace_name

  def initialize(app_name, workspace_name)
    super(app_name)
    @workspace_name = workspace_name
    @type = "dynamic-host"
    @port = 4200
  end

  def generate
    check_location
    create_project("projects/#{@project_name}")
    Dir.chdir("projects/#{@project_name}") do
      install_packages()
      add_icons()
      
      files = Dir.glob(File.join("../../../templates/#{@type}/app/", '*'))
      read_templates(files, 'src/app/', binding)

      @components.each do |component|
        component_name = to_lower_kebab_case(component[:name])
        component_dir = "src/app/#{component_name}"
        if !Dir.exist?(component_dir)
          system("ng generate component src/app/#{component[:name]}")
          file_path = "src/app/app.routes.ts"
          if (component_name === "not-found")
            new_content = "{\n\t\tpath: '**',\n\t\tcomponent: NotFoundComponent}"
            new_line = "import { NotFoundComponent } from './not-found/not-found.component';\n"
            add_route(file_path, new_content, new_line)
          elsif component_name === "home"
            new_content = "{\n\t\tpath: '',\n\t\tcomponent: HomeComponent,\n\t\tpathMatch: 'full'}"
            new_line = "import { HomeComponent } from './home/home.component';\n"
            add_route(file_path, new_content, new_line)
          end
        else
          puts("The component #{component_name} exists. It will not be generated again.")
        end
        files = Dir.glob(File.join("../../../templates/#{component_name}/", '*'))
        read_templates(files, "src/app/#{component_name}/", binding)
      end
    end
  end

  def configurate_project
    empty_json_file('projects/home/src/assets/federation.manifest.json')
    add_start_command(@project_name)
  end

end
