#! /usr/bin/env ruby

##
# Skyhook Services - Remote Init Script
##

$console = false
$LOAD_PATH << File.dirname(__FILE__)
require "init"


# parse input and run
case ARGV[0]
when "start"
  Skyhook.start
when "stop"
  Skyhook.stop
when "restart"
  Skyhook.restart
when "status"
  Skyhook.status
when "mode"
  ARGV.shift
  Mode.do(ARGV)
else
  which = ARGV.shift.to_s.split(".")
  action = Action.send(which[0].to_s.downcase.to_sym, which[1], *ARGV) rescue Process.exit(1)
  if !action
    Process.exit(1)
  end
end

Process.exit(0)
