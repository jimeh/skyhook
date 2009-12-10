class MaintenanceMode
  
  def enable
    Nginx.ensite  :maintenance
    Nginx.dissite :projects
    Nginx.dissite :default
    Initd.nginx :restart
    Projects.stop
  end
  
  def disable
    Nginx.ensite  :projects
    Nginx.ensite  :default
    Nginx.dissite :maintenance
    Projects.start
    Initd.nginx :restart
  end
  
end