#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'slim'
require 'rest-client'
require 'sinatra/activerecord'
require 'rack-flash'
require_relative '../config/environments'
require_relative './models/accounts'

set :port, ENV['PORT'] || 8080
set :bind, ENV['IP'] || '0.0.0.0'

helpers do
  def login?
    if session[:auth].nil? || session[:auth] == false
      return false
    else
      return true
    end
  end

  def login_admin?
    if session[:auth_admin].nil? || session[:auth_admin] == false
      return false
    else
      return true
    end
  end

  def login_super?
    if session[:auth_super].nil? || session[:auth_super] == false
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
  uname = params['inputUser']
  pass = params['inputPassword']

  # First check for super user
  if uname == ENV['APP_SUPER_UNAME'] and pass == ENV['APP_SUPER_PASSWD']
    session[:auth] = true
    session[:auth_admin] = true
    session[:auth_super] = true
    session[:auth_uname] = 'super'
    redirect '/author/home'
  end

  # Check for regular Administrator/User
  begin
    acc = Account.find_by(uname: uname)
    if acc.password == pass
      session[:auth] = true
      session[:auth_admin] = acc.is_super
      session[:auth_uname] = uname
      redirect '/author/home'
    end
  rescue
    # Do nothing, account not found.
  end

  redirect '/author/login'
end

##
# SSO Log out processor for author/admin/super users.
get '/author/logout' do
  session[:auth] = false
  session[:auth_admin] = false
  session[:auth_super] = false
  session[:auth_uname] = nil
  redirect '/'
end

##
# Dashboard home page for author/admin/super users.
get '/author/home' do
  redirect '/account/login' unless login?
  slim :author_home
end

##
# Users page of dashboard for admin/super users.
get '/author/users' do
  # This page requires at least admin privileges.
  redirect '/author/home' unless login_admin?
  slim :author_users
end