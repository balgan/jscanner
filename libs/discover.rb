#!/usr/bin/env ruby


class Discover 

  attr_accessor :url, :threads, :verbose
  
  def initialize(url, threads, verbose)
    @url = url
    @threads = threads
    @verbose = verbose
  end
  
end

	  
