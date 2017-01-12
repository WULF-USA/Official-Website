#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'slim'
require 'rest-client'
require 'json'
require 'rack-flash'

set :port, ENV['PORT'] || 8080
set :bind, ENV['IP'] || '0.0.0.0'

helpers do
  def login?
      #if session[:auth].nil? || session[:auth] == false
      #    return false
      #else
      #  return true
      #end
      return true
  end
end

##
# Index page of site.
get '/' do
   slim :index
end