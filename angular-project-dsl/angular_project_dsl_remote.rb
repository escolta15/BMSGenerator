require_relative 'angular_project_dsl.rb'

class AngularProjectDSLRemote < AngularProjectDSL
  attr_accessor :port, :workspace_name, :touch_screen

  def initialize(app_name, workspace_name, touch_screen)
    super(app_name)
    @workspace_name = workspace_name
    @type = "remote"
    @touch_screen = touch_screen
    @id = calculate_id
    @port = 4200 + @id 
  end

  def generate
    if !Dir.pwd.match?(@workspace_name)
      Dir.chdir(@workspace_name)
    end
    if !Dir.exist?("projects/#{@project_name}")
      create_project
      configurate_project
    else
      puts("The project #{@project_name} exists. It will not be created again.")
    end
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
        else
          puts("The component #{component_name} exists. It will not be generated again.")
        end
        files = Dir.glob(File.join("../../../templates/#{component_name}/", '*'))
        read_templates(files, "src/app/#{component_name}/", binding)
      end

      create_folder('models')
      @models = Dir.glob(File.join("../../../templates/#{@type}/models/", '*'))
      read_templates(@models, 'src/models/', binding)

      create_folder('guards')
      @guards = Dir.glob(File.join("../../../templates/#{@type}/guards/", '*'))
      read_templates(@guards, 'src/guards/', binding)
    end
  end

  private

  def calculate_id
    file_path = 'projects/home/src/assets/federation.manifest.json'
    file_content = File.read(file_path)
    data = JSON.parse(file_content)
    return data.size + 1
  end

  def modify_exposition(app_name)
    file_path = "projects/#{app_name}/federation.config.js"
    file_content = File.read(file_path)
    modified_content = file_content.gsub('./Component', './routes')
    final_content = modified_content.gsub('component.ts', 'routes.ts')
    File.open(file_path, 'w') { |file| file.write(final_content) }
  end

  def configurate_project
    add_remote_entry(@project_name, @port)
    file_path = 'projects/home/src/app/app.routes.ts'
    new_content = "{\n\t\tpath: '#{@project_name}',\n\t\tloadChildren: () => loadRemoteModule('#{@project_name}', './routes').then((m) => m.routes) }"
    new_line = ""
    if (@id === 1)
      new_line = "import { loadRemoteModule } from '@angular-architects/native-federation';\n"
    end
    add_route(file_path, new_content, new_line)
    modify_exposition(@project_name)
    add_start_command(@project_name)
  end

end
