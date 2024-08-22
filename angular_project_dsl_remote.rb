require_relative 'angular_project_dsl.rb'

class AngularProjectDSLRemote < AngularProjectDSL
  attr_accessor :port, :workspace_name, :touch_screen

  def initialize(app_name, workspace_name, touch_screen)
    super(app_name)
    @workspace_name = workspace_name
    @type = "remote"
    @touch_screen = touch_screen
    @port = 4201
  end

  # Generador
  def generate
    if !Dir.pwd.match?(@workspace_name)
      Dir.chdir(@workspace_name)
    end
    # Verifica si el directorio del proyecto ya existe
    if !Dir.exist?("projects/#{@project_name}")
      # Crea la estructura del proyecto Angular si no existe
      system("ng generate application #{@project_name} --ssr=false --routing --style=scss --skip-install=true")
      system("ng g @angular-architects/native-federation:init --project #{@project_name} --port #{@port} --type #{@type}")
      add_remote_entry(@project_name, @port)
      add_route(@project_name)
      add_start_command(@project_name)
    else
      puts("The project #{@project_name} exists. It will not be created again.")
    end
    # Ingresa en el directorio del proyecto
    Dir.chdir("projects/#{@project_name}") do
      install_packages()
      add_icons()
      
      # Personaliza el contenido del componente app utilizando plantillas ERB
      files = Dir.glob(File.join("../../../templates/#{@type}/app/", '*'))
      read_templates(files, 'src/app/', binding)

      # Genera los componentes
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

      # Genera los modelos
      create_folder('models')
      @models = Dir.glob(File.join("../../../templates/#{@type}/models/", '*'))
      read_templates(@models, 'src/models/', binding)
    end
  end

end
