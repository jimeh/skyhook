class SinatraDemoProject < Project
  
  def initialize
    @name = "sinatra_demo"                                      # Project name
    @path = "#{$projects_path}/#{@name}"                        # Local checkout path
    @revision = nil                                             # Default revision to checkout
    @repo = "https://heartbit.springloops.com/source/skyhookdemo/projects/sinatra_demo"
    super
  end
  
  def start
    file = "#{@path}/htdocs/config.ru"
    configru = File.read(file)
    File.open(file, "w+") do |f|
      f.write(configru.gsub("development", "production"))
    end
  end
  
end