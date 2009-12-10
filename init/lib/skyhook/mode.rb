class Mode
  
  @list = {}
  @status = {}
  
  class << self
    attr_accessor :list
    attr_reader :status
  end
  
  def self.enable(*args)
    self.switch(:enable, *args)
  end
  
  def self.disable(*args)
    self.switch(:disable, *args)
  end
  
  def self.switch(state, *args)
    if args.size > 0
      ret = true
      result = nil
      args.each do |mode|
        if @list.has_key?(mode.to_sym)
          if (state == :enable && !@status[mode.to_s]) || (state == :disable && @status[mode.to_s])
            self.display_switch(mode, state)
            result = @list[mode.to_sym].send(state) if @list[mode.to_sym].respond_to?(state)
            ret = false if result == false
            @status[mode.to_s] = (state == :enable) ? true : false
          else
            self.display_no_switch(mode, state)
          end
        else
          self.display_not_found(mode)
        end
      end
      self.save_status
      return ret
    end
  end
  
  def self.do(options = nil)
    if !options.nil?
      if options.is_a?(String)
        options = options.split(" ")
      end
      if options.is_a?(Array)
        options.each do |option|
          if option =~ /([\-\+])([a-z0-9]+)/
            state = ($1 == "+") ? :enable : :disable
            mode = $2.to_sym
            self.switch(state, mode)
          end
        end
      end
    end
  end
  
  def self.load_status
    if File.exist?("#{$modes_config_path}/status.yml")
      @status = YAML.load_file("#{$modes_config_path}/status.yml")
      return true
    end
    return false
  end

  def self.save_status(input = {})
    @status = @status.merge(input)
    File.open("#{$modes_config_path}/status.yml", "w") do |f|
      YAML.dump(@status, f)
    end
  end
  
  def self.display_switch(mode, state)
    msg = (state == :enable) ? "Enabling" : "Disabling"
    puts "#{msg} #{mode.to_s.camelize} mode"
  end
  
  def self.display_no_switch(mode, state)
    msg = (state == :enable) ? "enabled" : "disabled"
    puts "#{mode.to_s.camelize} mode is already #{msg}"
  end
  
  def self.display_not_found(mode)
    puts "ERROR: #{mode.to_s.camelize} mode does not exist"
  end
  
  
  def self.load
    self.save_status if !self.load_status
    Dir.glob("#{$modes_config_path}/*.rb").each do |item|
      item = item.gsub(/^.*\/(.*?)\.rb/, "\\1")
      require "modes/#{item}"
      @list[item.to_sym] = "#{item}Mode".camelize.constantize.new
      @status[item.to_s] = false if !@status.has_key?(item.to_s)
    end
    self.save_status
  end
  
end

Mode.load