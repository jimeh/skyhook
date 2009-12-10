class PermsAction < Action
    
  def ensure
    shell "chown -R www-data:www-data #{$skyhook_root}/www"
  end
  
end