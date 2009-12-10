class UpdateAction < Action
  
  def default
    skyhook
  end
  
  def all
    skyhook
    projects
  end
  
  def method_missing(project, *args)
    Projects.send(project).checkout(*args)
    Action.perms :ensure
  end
  
  def projects(*args)
    Projects.checkout(*args)
    Action.perms :ensure
  end
  
  def skyhook
    SVN.up(nil, $skyhook_root)
    shell "#{$skyhook_root}/init/rc.rb update.post_skyhook"
    if $console
      exec "irb -r #{$skyhook_root}/init/init.rb"
    end
  end
  
  def post_skyhook
    Action.perms :ensure
    Projects.init
  end
  
end