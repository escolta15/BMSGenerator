class AngularProjectDSL

  def initialize(touch_screen)
    @project_name = touch_screen.name
    @packages = []
    @touch_screen = touch_screen
    @components = []
    @models = []
  end

  def package(name, version)
    @packages << { name: name, version: version }
  end

  def component(name)
    @components << { name: name }
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

  # Generador
  def generate
    # Verifica si el directorio del proyecto ya existe
    if !Dir.exist?("projects/#{@project_name}")
      # Crea la estructura del proyecto Angular si no existe
      system("ng generate application #{@project_name} --ssr=false --routing --style=scss --skip-install=true")
      system("ng g @angular-architects/native-federation:init --project #{@project_name} --port 4201 --type remote")
      add_remote_entry(@project_name, 4201)
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
      files = Dir.glob(File.join('../../../templates/app/', '*'))
      read_templates(files, 'src/app/', binding)

      # Genera los componentes
      @components.each do |component|
        component_name = component[:name]

        # Verifica si el directorio del componente ya existe
        component_dir = "src/app/#{component_name}"
        if !Dir.exist?(component_dir)
          # Genera el componente si no existe
          system("ng generate component src/app/#{component[:name]}")
        else
          puts("The component #{component_name} exists. It will not be generated again.")
        end
        
        # Modifica el archivo del componente
        files = Dir.glob(File.join("../../../templates/#{component_name}/", '*'))
        read_templates(files, "src/app/#{component_name}/", binding)
      end

      # Genera los modelos
      create_folder('models')
      @models = Dir.glob(File.join('../../../templates/models/', '*'))
      read_templates(@models, 'src/models/', binding)
    end
  end

  private

  # Metodo para instalar los paquetes npm
  def install_packages()
    @packages.each do |package|
      # Ejecuta el comando npm install para instalar el paquete
      system("npm install #{package[:name]}@#{package[:version]}")
    end
  end

  # Metodo para agregar los iconos al archivo de estilos
  def add_icons
    read_templates(['../../../templates/index.html.erb'], 'src/', binding)
  end

  # Metodo para crear una carpeta
  def create_folder(name)
    folder = "src/#{name}"
    if !Dir.exist?(folder)
      # Si no existe, crea la carpeta
      Dir.mkdir(folder)
    end
  end

  # Metodo para leer las plantillas
  def read_templates(files, path, data_binding)
    for file in files
      filename = find_file(file)
      file_path = "#{path}#{filename}"

      # Leer la plantilla ERB desde el archivo
      erb_template = File.read("#{file}")

      # Crear una instancia de la clase ERV
      erb = ERB.new(erb_template)

      # Realizar el enlace de datos utilizando el contexto de binding proporcionado
      result = erb.result(data_binding)

      # Escribe el contenido modificado de vuelta al archivo
      File.open(file_path, "w") { |file| file.write(result) }
    end
  end

  # Metodo para coger el nombre del archivo
  def find_file(file)
    parts = file.split('/')
    filename = parts.find { |part| part.end_with?(".erb") }
    filename = filename.sub(/\.erb$/, '')
    return filename
  end

end
