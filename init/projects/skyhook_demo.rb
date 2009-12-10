class SkyhookDemoProject < Project
  
  def initialize
    @name = "skyhook_demo"                              # Project name
    @path = "#{$projects_path}/#{@name}"                # Local checkout path
    @revision = nil                                     # Default revision to checkout
    @repo = "https://heartbit.springloops.com/source/skyhookdemo/projects/skyhook_demo"
    super
  end
  
  def start
    # shell "export RAILS_ENV=production; #{@path}/htdocs/script/delayed_job start"
  end
  
  def stop
    # shell "export RAILS_ENV=production; #{@path}/htdocs/script/delayed_job stop"
  end
  
  def restart
    # stop
    # start
  end
  
end