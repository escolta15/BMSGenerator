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
    create_native_project
  end

  def configurate_project
    empty_json_file('projects/home/src/assets/federation.manifest.json')
    add_start_command(@project_name)
  end

  def generate_component(component, name)
    system("ng generate component src/app/#{component[:name]}")
    file_path = "src/app/app.routes.ts"
    if (name === "not-found")
      new_content = "{\n\t\tpath: '**',\n\t\tcomponent: NotFoundComponent}"
      new_line = "import { NotFoundComponent } from './not-found/not-found.component';\n"
      add_route(file_path, new_content, new_line)
    elsif name === "home"
      new_content = "{\n\t\tpath: '',\n\t\tcomponent: HomeComponent,\n\t\tpathMatch: 'full'}"
      new_line = "import { HomeComponent } from './home/home.component';\n"
      add_route(file_path, new_content, new_line)
    end
  end

end
