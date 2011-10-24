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
rescue LoadError => e
  puts "[ERROR] Install missing ruby gem. Please see README file or http://code.google.com/p/wpscan/"
  puts e.inspect
  exit(1)
end



url = ''
find_version = false
enumerate_plugins = false
generate_plugin_list = 0
threads = 10
verbose = false
@version = "0.1"

#introduction

def introduction()

puts " Joomla Scanner by @balgan version " +  @version

end



















