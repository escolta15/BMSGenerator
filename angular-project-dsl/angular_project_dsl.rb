class AngularProjectDSL

  def initialize(app_name)
    @project_name = app_name
    @packages = []
    @components = []
    @models = []
    @guards = []
    @type = ""
  end

  def package(name, version, isDev)
    params = ""
    if isDev
      params = "-D"
    end
    @packages << { name: name, version: version, params: params }
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

  def add_route(routes_path, new_content, new_line = "")
    puts Dir.pwd
    content = File.read(routes_path)
    regex = /(\[\s*)([^\]]*)(\s*\])/
    final_content = content.gsub(regex) do |match|
      opening_bracket = $1
      array_content = $2.strip
      closing_bracket = $3
      if array_content.empty?
        "#{opening_bracket}\n\t#{new_content}#{closing_bracket}"
      else  
        "#{opening_bracket}#{new_content},\n\t#{array_content}#{closing_bracket}"
      end
    end
    File.open(routes_path, 'w') do |file|
      file.write(new_line + final_content)
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

  def empty_json_file(file_path)
    empty_json = {}.to_json
    File.open(file_path, 'w') do |file|
      file.write(empty_json)
    end
  end

  # Generador
  def generate
    raise NotImplementedError
  end

  private

  # Metodo para instalar los paquetes npm
  def install_packages()
    @packages.each do |package|
      # Ejecuta el comando npm install para instalar el paquete
      system("npm install #{package[:name]}@#{package[:version]} #{package[:params]}")
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

  def to_lower_kebab_case(text)
    text
      .strip
      .gsub(/\s+/, '-')
      .gsub(/([a-z])([A-Z])/, '\1-\2')
      .downcase
  end

end
