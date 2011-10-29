#!/usr/bin/env ruby
#This work is strongly based on the work done on Wordpress scanner by Ryan Dewhurst aka Ethicalhack3r
#For that reason some code will be similar or even equal to wordpress scanner, it is an amazing tool
#and you should go and try it


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

# Output runtime data

puts '| URL: ' + url.to_s
puts '| Started on ' + Time.now.asctime
puts 

# Create the discover object

discover = Discover.new(url, threads, verbose)

# Is the readme.html file there?

if discover.readme_exists
  puts "[!] The Joomla \"" + url.to_s  + "README.txt\" file exists."
  puts
end

# Is there a error_log file in the plugins dir?

if discover.error_log
  puts "[!] A Joomla error_log file has been found: " + url.to_s + "/error_log/"
  puts
end

extensions_found = discover.find_extension


find_version = discover.readme_version
unless find_version == false or find_version == '' or find_version.nil?
  puts  "[!] A readme was found and according to it the Joomla version is: " + find_version.to_s.gsub(/\s+/, "")
  puts
  #searches on exploit db for version without any whitespaces
  discover.search_exploitdb(find_version.to_s.gsub(/\s+/, ""))
else #in future modify this part to do a different type of search as README.txt exists in 1.6.x and 1.7.x
  gen_version = discover.advanced_version_finder
unless gen_version == false or gen_version == '' or gen_version.nil?
  puts '[!] Joomla version ' + gen_version.to_s  + ' according to meta.'
  
else
  puts "[ :-( ] Nothing found!"
end
end


puts '[+] Finished at ' + Time.now.asctime
exit() # must exit!
