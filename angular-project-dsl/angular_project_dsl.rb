class AngularProjectDSL

  def initialize(name)
    @project_name = name
    @packages = []
    @components = []
    @models = []
    @guards = []
    @type = ""
  end

  def generate
    raise NotImplementedError
  end

  def add_package(name, version, is_dev)
    params = ""
    if is_dev
      params = "-D"
    end
    @packages << { name: name, version: version, params: params }
  end

  def add_component(name)
    @components << { name: name }
  end

  private

  def install_packages
    @packages.each do |package|
      system("npm install #{package[:name]}@#{package[:version]} #{package[:params]}")
    end
  end

  def add_icons
    read_templates(['../../../templates/index.html.erb'], 'src/', binding)
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

  def create_folder(name)
    folder = "src/#{name}"
    if !Dir.exist?(folder)
      Dir.mkdir(folder)
    end
  end

  def read_templates(files, path, data_binding)
    for file in files
      filename = find_file(file)
      file_path = "#{path}#{filename}"

      erb_template = File.read("#{file}")

      erb = ERB.new(erb_template)

      result = erb.result(data_binding)

      File.open(file_path, "w") { |file| file.write(result) }
    end
  end

  def find_file(file)
    parts = file.split('/')
    filename = parts.find { |part| part.end_with?(".erb") }
    filename = filename.sub(/\.erb$/, '')
    return filename
  end

  def empty_json_file(file_path)
    empty_json = {}.to_json
    File.open(file_path, 'w') do |file|
      file.write(empty_json)
    end
  end

  def to_lower_kebab_case(text)
    text
      .strip
      .gsub(/\s+/, '-')
      .gsub(/([a-z])([A-Z])/, '\1-\2')
      .downcase
  end

  def create_project
    system("ng generate application #{@project_name} --ssr=false --routing --style=scss --skip-install=true")
    system("ng g @angular-architects/native-federation:init --project #{@project_name} --port #{@port} --type #{@type}")
  end

  def configurate_project
    raise NotImplementedError
  end

end
