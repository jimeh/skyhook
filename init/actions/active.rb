class ActiveAction < Action
  
  def default
    puts "please specify project"
  end
  
  def method_missing(project, *args)
    puts Projects.send(project).status["active"]
  end
  
  def all
    Projects.list.each do |name, project|
      puts "#{name.camelize}: #{project.status["active"]}"
    end
  end
  
end