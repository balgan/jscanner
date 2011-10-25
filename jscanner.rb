#!/usr/bin/env ruby



$: << '.'


begin

 # standard libs
  require 'rubygems'
  require 'getoptlong'
  require 'uri'
  require 'time'
  require 'resolv'
  require 'xmlrpc/client'
  require 'digest/md5'
  require 'readline'
  require 'base64'
  require 'cgi'
 # third party libs
  require 'typhoeus'
  require 'xmlsimple'
 #our libs
  require 'libs/discover'
rescue LoadError => e
  puts "[ERROR] Install missing ruby gem."
  puts e.inspect
  exit(1)
end



url = ''
find_version = false
enumerate_plugins = false
generate_plugin_list = 0
plugin_list = false
threads = 10
verbose = false
@version = "0.1"

#introduction

def introduction()

puts " Joomla Scanner by @balgan version " +  @version

end


def help()

  script_name = $0 
  puts 
  puts "Examples:"
  puts
  puts "Check version of Joomla! on the url"
  puts "ruby " + script_name + " --version --url www.example.com"
  puts "Enumerate Joomla! plugins on the url"
  puts "ruby " + script_name + " --plugins --url www.example.com"
  puts "Show plugin list currently supported by Joomla Scanner"
  puts "ruby " + script_name + " --show-plugins"

  puts "Use -v for verbose output"
  
  puts 'See README for further information.'
	
end

introduction()
puts


# show usage if 0 arguments

if ARGV.length == 0
  help()
  exit(1)
end

options = GetoptLong.new(
  ["--url", GetoptLong::OPTIONAL_ARGUMENT],
  ["--version", GetoptLong::OPTIONAL_ARGUMENT],
  ["--plugins", GetoptLong::OPTIONAL_ARGUMENT],
  ["--show-plugins",GetoptLong::OPTIONAL_ARGUMENT],
  ["-v", GetoptLong::OPTIONAL_ARGUMENT] 
) 

begin

	options.each do |opt,arg|
	
	case opt 
	 
	 	when '--url'
	 	 if  arg.nil? or arg == ""
	          puts "[ERROR] No URL supplied."
        	  exit(1)
        	 else
	          url = arg
        	end
        	
        	when '--enumerate'
         	  enum_plugins = true	 
		
		
		when '--version'
		  find_version = true
	          
	   	
	   	when '--show-plugins'
	   	  plugin_list = true
	   	  
	end
end
      
rescue
introduction()
help()
exit(1)
end


