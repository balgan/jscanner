#!/usr/bin/env ruby

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
#Not the cleanest method but works for now  
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
      if response.body =~ %r{PHP Fatal error}i
        exists = true
      end
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


end
