##
# Skyhook Services - Libraries
##

require "yaml"
require "fileutils"
require "lib/skyhook/utils"
require "lib/skyhook/utils/initd"
require "lib/skyhook/utils/monit"
require "lib/skyhook/utils/nginx"
require "lib/skyhook/utils/object_overloads"
require "lib/skyhook/utils/svn"
require "lib/skyhook/project"
require "lib/skyhook/projects"
require "lib/skyhook/action"
require "lib/skyhook/mode"

class Skyhook
  
  @info = {}
  
  class << self
    attr_accessor :info
  end
  
  def self.start
    save_status if !load_status
    if !@info.nil? && (!@info.has_key?(:booted) || @info[:booted] != true)
      save_status({:booted => true})
    end
    if !Nginx.restore_enabled
      Nginx.ensite("projects")
      Nginx.ensite("default")
      Nginx.ensite("monit-status")
    end
    Projects.boot
    Action.perms :ensure
    puts "Starting Skyhook services."
    Initd.monit :start
    sleep 1
    Monit.start :all
    sleep 1
    Projects.start
    write_status(1)
  end

  def self.stop
    puts "Stopping Skyhook services."
    Projects.stop
    Monit.stop :all
    sleep 1
    Initd.monit :stop
    write_status(0)
  end

  def self.restart
    puts "Restarting Skyhook services."
    Projects.restart
    Monit.restart :all
    sleep 1
    Initd.monit :restart
  end

  def self.status
    if File.exist?($status_file)
      puts "Skyhook services are running."
    else
      puts "Skyhook services are not running."
    end
  end
  
  def self.method_missing(method, *args)
    call = (args.size > 0) ? args.shift : nil
    Action.send(method, call, *args)
  end
  
  def self.load_status
    if File.exist?("#{$skyhook_root}/init/status.yml")
      @info = YAML.load_file("#{$skyhook_root}/init/status.yml")
      return true
    end
    return false
  end

  def self.save_status(input = {})
    @info = @info.merge(input)
    File.open("#{$skyhook_root}/init/status.yml", "w") do |f|
      YAML.dump(@info, f)
    end
  end
  
end
