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

enable :sessions

helpers do
  def login?
    return (!session[:auth].nil? and (session[:auth] == true))
  end

  def login_admin?
    return (!session[:auth_admin].nil? and (session[:auth_admin] == true))
  end

  def login_super?
    return (!session[:auth_super].nil? and (session[:auth_super] == true))
  end
end

##
# Index page of site.
get '/' do
  # Display view.
  slim :index
end

##
# Login for author/admin/super users.
get '/sso/author/login' do
  # Display view.
  slim :author_login
end

##
# SSO Login processor for author/admin/super users.
post '/sso/author/login' do
  # Copy in parameters for sanatizing.
  uname = params['inputUser']
  pass = params['inputPassword']

  # TODO: Sanatize variables uname and pass.
  
  # First check for super user
  if uname == ENV['APP_SUPER_UNAME'] and pass == ENV['APP_SUPER_PASSWD']
    # Success. Modify session cookies.
    session[:auth] = true
    session[:auth_admin] = true
    session[:auth_super] = true
    session[:auth_uname] = 'super'
    # Redirect to dashboard.
    redirect '/author/home'
    return
  end

  # Check for regular Administrator/User
  begin
    # Search DB by username.
    acc = Account.find_by(username: uname)
    # Verify password hashes match.
    if acc.password == pass
      # Success. Modify session cookies.
      session[:auth] = true
      session[:auth_admin] = acc.is_super
      session[:auth_uname] = uname
      # Redirect to dashboard.
      redirect '/author/home'
      return
    end
  rescue
    # Do nothing, account not found.
  end
  
  # Invalid login credentials. Redirect to log in page.
  redirect '/sso/author/login'
end

##
# SSO Log out processor for author/admin/super users.
get '/sso/author/logout' do
  # Reset all session cookies.
  session[:auth] = false
  session[:auth_admin] = false
  session[:auth_super] = false
  session[:auth_uname] = nil
  # Redirect to home page.
  redirect '/'
end

##
# Dashboard home page for author/admin/super users.
get '/author/home' do
  # This page requires at least user privileges.
  redirect '/sso/author/login' unless login?
  # Display view.
  slim :author_home
end

##
# Users page of dashboard for admin/super users.
get '/author/users' do
  # This page requires at least admin privileges.
  redirect '/author/home' unless login_admin?
  # Fetch all user accounts.
  @users = Account.all.order(:id)
  # Display view.
  slim :author_users
end

##
# SSO Account modifier for deleting accounts.
post '/sso/author/remove/:uname' do
  # This page requires at least administrator privileges.
  redirect '/author/home' unless login_admin?
  begin
    # Find user account by username.
    acc = Account.find_by(username: params['uname'])
    # Destroy the account.
    acc.destroy
  rescue
    # User does not exist.
  end
  # Redirect to users dashboard page.
  redirect '/author/users'
end

##
# SSO Account modifier for updating passwords.
post '/sso/author/pass/:uname' do
  # This page requires at least adminstrator privileges.
  redirect '/author/home' unless login_admin?
  begin
    # Find user account by username.
    acc = Account.find_by(username: params['uname'])
    # Update password value (Hashing done by ActiveRecord model object).
    acc.password = params['newpassword']
    # Save new model object state to DB.
    acc.save!
  rescue
    # User does not exist or some kind of save error occured.
  end
  # Redirect to users dashboard page.
  redirect '/author/users'
end

##
# SSO Account modifier for creating new accounts.
post '/sso/author/new' do
  # This page requires at least administrator privileges.
  redirect '/author/home' unless login_admin?
  begin
    # Create new Account model object.
    acc = Account.new()
    # Fill in all needed values.
    acc.username = params['username']
    acc.password = params['password']
    if params['type'] == 'admin'
      acc.is_super = true
    else
      acc.is_super = false
    end
    # Save new model object to DB.
    acc.save!
  rescue
    # User does not exist or some kind of save error occured.
  end
  # Redirect to users dashboard page.
  redirect '/author/users'
end

##
# Catch-all 404 error handler.
not_found do
  # Display view.
  slim :not_found
end