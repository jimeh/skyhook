class Monit
  
  def self.method_missing(cmd, *args)
    if $debug.nil? || $debug <= 1
      shell "monit #{cmd.to_s} " + args.map { |i| i.to_s }.join(" ")
    else
      puts "DEBUG: monit #{cmd.to_s} " + args.map { |i| i.to_s }.join(" ")
    end
  end
  
end