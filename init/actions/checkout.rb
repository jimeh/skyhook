class CheckoutAction < Action
  
  def default
    puts "please specify project"
  end
  
  def method_missing(project, *args)
    Projects.send(project).checkout(*args)
  end
  
  def all
    Projects.checkout
  end
  
end