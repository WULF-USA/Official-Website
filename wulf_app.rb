#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'slim'
require 'rest-client'
require 'sinatra/activerecord'
require 'rack-flash'
require 'action_view'
require 'resque'
require 'redis'
require 'dalli'
require 'sinatra/r18n'
require 'sinatra/flash'
require_relative './config/environments'
require_relative './models/accounts'
require_relative './models/feeds'
require_relative './models/articles'
require_relative './models/resources'
require_relative './models/videos'
require_relative './routes/about'
require_relative './routes/blog'
require_relative './routes/errors'
require_relative './routes/home'
require_relative './routes/news'
require_relative './routes/resources'
require_relative './routes/sso'
require_relative './routes/videos'
require_relative './routes/author_blog'
require_relative './routes/author_home'
require_relative './routes/author_news'
require_relative './routes/author_resources'
require_relative './routes/author_traffic'
require_relative './routes/author_users'
require_relative './routes/author_videos'
require_relative './helpers/login'
require_relative './helpers/lang'
require_relative './helpers/notifications'
require_relative './lib/tracking'

class WulfApp < Sinatra::Base

  include ActionView::Helpers::SanitizeHelper
  include Lib::Tracking
  include R18n::Helpers
  
  #use ActiveRecord::QueryCache
  
  R18n.default_places = './i18n/'
  
  enable :sessions
  
  helpers Helpers::Login
  helpers Helpers::Internationalization
  helpers Helpers::Notifications
  
  register Sinatra::R18n
  register Sinatra::Flash
  set :root, File.dirname(__FILE__)
  
  register Routing::About
  register Routing::Blog
  register Routing::Errors
  register Routing::Home
  register Routing::News
  register Routing::Resources
  register Routing::SSO
  register Routing::Videos
  register Routing::Author::Blog
  register Routing::Author::Home
  register Routing::Author::News
  register Routing::Author::Resources
  register Routing::Author::Traffic
  register Routing::Author::Users
  register Routing::Author::Videos
  
  configure :development do
    enable :logging
  end
end