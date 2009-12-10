class Action

  @list = {}
  
  class << self
    attr_accessor :list
  end
  
  def default
    puts "no default action defined"
  end
  
  def self.method_missing(action, call = nil, *args)
    if @list.has_key?(action)
      call = :default if call.nil?
      @list[action].send(call, *args) rescue return false
      return true
    end
    return false
  end
  
  def self.load
    Dir.glob("#{$actions_config_path}/*.rb").each do |item|
      item = item.gsub(/^.*\/(.*?)\.rb/, "\\1")
      require "actions/#{item}"
      @list[item.to_sym] = "#{item}Action".camelize.constantize.new
    end
  end
  
end

Action.load