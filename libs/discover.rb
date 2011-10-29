#!/usr/bin/env ruby
require "uri"
class Discover

  attr_accessor :url, :threads, :verbose

  def initialize(url, threads, verbose)
    @url = url
    @threads = threads
    @verbose = verbose
  end


#Checks if README.txt exists
def readme_exists

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
  
  #This version of finder will try to find if the website is running Joomla and what version using the generator tag
  #This is based on this website http://www.thinkbigshot.com/blog/technical/186-how-to-detect-if-a-site-uses-joomla.html
  
  
  def advanced_version_finder
    
    version = false
    response = Typhoeus::Request.get(@url.to_s)
    

    # follow redirects...

    until response.code !~ /30/
      response = Net::HTTP.get_response(URI.parse(response.headers_hash['location']))
    end

    version = response.body[%r{name="generator" content="Joomla! (.*)"}i, 1]

     
  end

  
#Attempts to access the error logs of Joomla

  def error_log

    exists = false
  if(url.to_s[-1,1]=="/")
    response = Typhoeus::Request.get(@url.to_s + 'logs/')
  else
     response = Typhoeus::Request.get(@url.to_s + '/logs/')
  end
    if response.code == 200
       puts
       puts "[!]Logs folder publicly accessible at " + response.effective_url.to_s
       puts
    else
     puts
     puts "[!]Logs folder !! NOT!! publicly accessible at " +  response.effective_url.to_s
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
  
  

def find_extension
    
    exists = false

    response = Typhoeus::Request.get(@url.to_s)
        response.body.scan(/(.*)extension(.*)/) do
        |link|
        puts "[!] An extension was found: "
        puts link
        puts
    end

    exists
    
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
    end
    
  end

end
