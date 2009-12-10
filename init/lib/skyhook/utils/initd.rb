class Initd
  
  def self.method_missing(service, *args)
    if $debug.nil? || $debug <= 1
      shell "/etc/init.d/#{service.to_s} " + args.map { |i| i.to_s }.join(" ") if File.exist?("/etc/init.d/#{service.to_s}")
    else
      puts "DEBUG: /etc/init.d/#{service.to_s} " + args.map { |i| i.to_s }.join(" ")
    end
  end
  
end