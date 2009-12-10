if !$LOAD_PATH.include?(File.dirname(__FILE__))
  $LOAD_PATH << File.dirname(__FILE__)
end

require "config"
require "lib/skyhook"
$console = true if $console.nil?

# $debug = 2