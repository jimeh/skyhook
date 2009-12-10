class HasLatestAction < Action
  
  def default
    Projects.has_latest?
  end
  
  def method_missing(*args)
    Projects.has_latest?(*args)
  end
  
end