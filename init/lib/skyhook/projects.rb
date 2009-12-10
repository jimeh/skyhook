##
# Skyhook Services - Require projects
##

class Projects
  
  @list = {}
  
  class << self
    attr_accessor :list
  end
  
  def self.method_missing(method, *args)
    if @list.has_key?(method)
      return @list[method]
    else
      return self.do(method, *args)
    end
  end
  
  def self.checkout(*args)
    if args.size > 0
      return self.do_on_projects(*(args << :update))
    else
      return self.do(:update)
    end
  end
  
  def self.activate(*args)
    if args.size > 0
      return self.do_on_projects(*(args << :activate))
    else
      return self.do(:activate)
    end
  end
  
  def self.has_latest?(*args)
    ret = self.do_on_projects(*(args << :has_latest?))
    puts (ret) ? "yes" : "no"
    return ret
  end
  
  def self.load
    Dir.glob("#{$projects_config_path}/*.rb").each do |item|
      item = item.gsub(/^.*\/(.*?)\.rb/, "\\1")
      require "projects/#{item}"
      @list[item.to_sym] = "#{item}Project".camelize.constantize.new
    end
  end
  
private
  
  def self.do(what, *args)
    ret = true
    result = nil
    @list.each do |name, project|
      result = project.send(what, *args) if project.respond_to?(what)
      ret = false if result == false
    end
    return ret
  end
  
  def self.do_on_projects(*args)
    if args.size > 0
      method = args.pop.to_sym
      if args.size > 0
        ret = true
        result = nil
        args.each do |item|
          if @list.has_key?(item.to_sym)
            result = @list[item.to_sym].send(method)
            ret = false if result == false
          end
        end
        return ret
      else
        return self.do(method)
      end
    end
  end
  
end

Projects.load


