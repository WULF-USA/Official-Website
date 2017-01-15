#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'slim'
require 'rest-client'
require 'sinatra/activerecord'
require 'rack-flash'
require_relative '../config/environments'

set :port, ENV['PORT'] || 8080
set :bind, ENV['IP'] || '0.0.0.0'

helpers do
    def login?
        return true
    end
    def super_login?
        if session[:super_auth].nil? || session[:super_auth] == false
          return false
        else
            return true
        end
    end
end

##
# Index page of site.
get '/' do
    slim :index
end

##
# Login for author/admin/super users.
get '/author/login' do
    slim :author_login
end

##
# SSO Login processor for author/admin/super users.
post '/author/login' do
    
end

##
# Dashboard home page for author/admin/super users.
get '/author/home' do
    # TODO: Check if user is logged in.
    slim :author_home
end

##
# Users page of dashboard for admin/super users.
get '/author/users' do
    # TODO: Check if user is logged in.
    slim :author_users
end