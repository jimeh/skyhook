class ActivateAction < Action
  
  def default
    puts "please specify project"
  end
  
  def method_missing(project, *args)
    Projects.send(project).activate(*args)
    Action.perms :ensure
  end
  
  def all
    Projects.activate
    Action.perms :ensure
  end
  
end