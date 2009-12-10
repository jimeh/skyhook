class Nginx
  
  @sites_enabled = []
  @nginx_conf = "#{$nginx_config_path}"
  @available_path = "#{@nginx_conf}/sites-available"
  @enabled_path = "#{@nginx_conf}/sites-enabled"
  
  class << self
    attr_accessor :sites_enabled
    attr_accessor :nginx_conf
    attr_accessor :available
    attr_accessor :enabled
  end
  
  def self.restore_enabled
    if @sites_enabled.size > 0
      @sites_enabled.each do |site|
        self.ensite(site)
      end
      return true
    end
    return false
  end
  
  def self.ensite(site)
    if File.exist?("#{@available_path}/#{site.to_s}")
      self.dissite(site)
      if $debug.nil? || $debug <= 1
        shell "ln -s \"#{@available_path}/#{site.to_s}\" \"#{@enabled_path}/#{site.to_s}\""
        @sites_enabled << site.to_s
        self.save_status
      else
        puts "DEBUG: ln -s \"#{@available_path}/#{site.to_s}\" \"#{@enabled_path}/#{site.to_s}\""
      end
    end
  end
  
  def self.dissite(site)
    if File.exist?("#{@enabled_path}/#{site.to_s}")
      if $debug.nil? || $debug <= 1
        shell "rm \"#{@enabled_path}/#{site.to_s}\""
        @sites_enabled.delete(site.to_s)
        self.save_status
      else
        puts "DEBUG: rm \"#{@enabled_path}/#{site.to_s}\""
      end
    end
  end
  
  def self.load_status
    if File.exist?("#{$skyhook_root}/init/sites-enabled.yml")
      @sites_enabled = YAML.load_file("#{$skyhook_root}/init/sites-enabled.yml")
      return true
    end
    return false
  end

  def self.save_status(input = [])
    @sites_enabled = @sites_enabled + input
    File.open("#{$skyhook_root}/init/sites-enabled.yml", "w") do |f|
      YAML.dump(@sites_enabled, f)
    end
  end
  
end

Nginx.save_status if !Nginx.load_status