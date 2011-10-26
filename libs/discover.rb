#!/usr/bin/env ruby
require "uri"
class Discover

  attr_accessor :url, :threads, :verbose

  def initialize(url, threads, verbose)
    @url = url
    @threads = threads
    @verbose = verbose
  end

  def readme_exists?

    exists = false

    response = Typhoeus::Request.get(@url.to_s + 'README.TXT')
    
    if response.code == 200
      if response.body =~ %r{Joomla! Official site: http://www.joomla.org}i
        exists = true
      end
    end

    exists

  end

#Attempts to find the Joomla version by reading the README.txt and extracting the text
#Not the cleanest method but works for now  versions 1.6.x 1.7.x
# TODO: IMPROVE THIS METHOD OF SEARCH IN FUTURE
  def readme_version

    version = false

    response = Typhoeus::Request.get(@url.to_s + 'README.TXT')

    if response.code == 200
      #if response.body =~ %r{Joomla! Official site: http://www.joomla.org}i
         version = response.body[80,10]
        exists = true
     # end
    end
  version
    
  end

  
#Attempts to access the error logs of Joomla

  def error_log

    exists = false

    response = Typhoeus::Request.get(@url.to_s + 'logs/')

    if response.code == 200
     puts
     puts "[!]Logs folder publicly accessible at " + url.to_s + "logs/"
     puts
     else
     puts
     puts "[!]Logs folder !! NOT!! publicly accessible at " + url.to_s + "logs/"
     puts
    end

    exists

  end

  
  # Check for plugins using directory listing

  def directory_listing?(plugin)

    listing = false

    response = Typhoeus::Request.get(@url.to_s + '/plugins/' + plugin + '/')

    if response.body[%r{<title>Index of}]
      listing = true
    end

    listing

  end


  def search_exploitdb(version)
    @url1 = "http://www.exploit-db.com/search/?action=search&filter_page=1&filter_description=&filter_exploit_text=Joomla+" 
    @url2 = "&filter_author=&filter_platform=0&filter_type=0&filter_lang_id=0&filter_port=&filter_osvdb=&filter_cve="
    @version = version
    version[".x"]= ""
    puts "[?] SEARCHING: Joomla+" +@version.to_s + " at " + @url1.to_s + @version.to_s + @url2.to_s 
    response = Typhoeus::Request.get(@url1.to_s + @version.to_s + @url2.to_s )
    response.body.scan(/(.*)\/exploits\/(.*)/) do
    |link|
    puts link
    #gsub(/href=['"]/)
    end
    
  end

end
