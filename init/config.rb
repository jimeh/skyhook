##
# Skyhook Services - Config
##

# config
$skyhook_root  = File.dirname(File.dirname(__FILE__.gsub(/^.\/(.*)$/, "#{ENV["PWD"]}/\\1")))
$checkout_path = "/mnt/system"
$projects_path = "#{$skyhook_root}/www/projects"
$status_file   = "#{$skyhook_root}/init/status.tmp"

$nginx_config_path          = "#{$skyhook_root}/etc/nginx"
$nginx_projects_config_path = "#{$nginx_config_path}/projects"
$projects_config_path       = "#{$skyhook_root}/init/projects"
$actions_config_path       = "#{$skyhook_root}/init/actions"
$modes_config_path       = "#{$skyhook_root}/init/modes"
