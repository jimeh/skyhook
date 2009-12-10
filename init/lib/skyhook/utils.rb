
# utility methods
def shell(*args)
  if $debug.nil? || $debug > 1
    send(:system, *args)
  else
    puts "DEBUG: " + args.join(" ")
  end
end

def write_status(status)
  case status
  when 1
    shell "echo '1' > #{$status_file}"
  when 0
    shell "rm #{$status_file}"
  end
end
