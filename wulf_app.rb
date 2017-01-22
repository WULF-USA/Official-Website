#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'slim'
require 'rest-client'
require 'sinatra/activerecord'
require 'rack-flash'
require 'action_view'
require_relative './config/environments'
require_relative './models/accounts'
require_relative './models/feeds'
require_relative './models/articles'
require_relative './models/resources'
require_relative './models/videos'

class WulfApp < Sinatra::Base

  include ActionView::Helpers::SanitizeHelper
  
  enable :sessions
  
  helpers do
    def login?
      #return true if is_ci?
      return (!session[:auth].nil? and (session[:auth] == true))
    end
  
    def login_admin?
      #return true if is_ci?
      return (!session[:auth_admin].nil? and (session[:auth_admin] == true))
    end
  
    def login_super?
      #return true if is_ci?
      return (!session[:auth_super].nil? and (session[:auth_super] == true))
    end
    
    def is_logged_in?
      #return true if is_ci?
      return (login? or login_admin? or login_super?)
    end
    
    def is_ci?
      return (ENV['CI'] == 'true')
    end
    
    def login_username
      return Nil unless is_logged_in?
      return session[:auth_uname] unless login_super?
      return 'super'
    end
  end
  
  ##
  # Index page of site.
  get '/' do
    # Retrieve all news listings.
    @feeds = Feed.all.order(created_at: :desc).limit(4)
    # Retrieve all blog posts.
    @posts = Article.all.order(created_at: :desc).limit(5)
    # Retrieve all video link listings.
    @videos = Video.all.order(created_at: :desc).limit(3)
    # Display view.
    slim :index
  end
  
  ##
  # Resources listing of site.
  get '/resources' do
    # Retrieve resource list.
    @resources = Resource.all.order(title: :asc)
    # Display view.
    slim :resource_list
  end
  
  ##
  # Blog listing of site.
  get '/blog' do
    # Retrieve all blog posts.
    @posts = Article.all.order(created_at: :desc)
    # Display View
    slim :blog_list
  end
  
  ##
  # Blog listing of site.
  get '/videos' do
    # Retrieve all video link posts.
    @videos = Video.all.order(created_at: :desc)
    # Display View
    slim :video_list
  end
  
  ##
  # Article view page of site.
  get '/blog/:id' do
    # Retrieve post content.
    @post = Article.find_by(id: params[:id])
    # Display View.
    slim :blog_item
  end
  
  ##
  # News item page of site.
  get '/news/:id' do
    # Retrieve post object by ID from DB.
    @item = Feed.find_by(id: params['id'])
    # Display view.
    slim :news_item
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
  # News page of dashboard for author/admin/super users.
  get '/author/news' do
    # This page requires at least user privileges.
    redirect '/author/home' unless login?
    # Fetch all user accounts.
    @feeds = Feed.all.order(:id)
    # Display view.
    slim :author_news
  end
  
  ##
  # Create news item page of dashboard for author/admin/super users.
  get '/author/news/create' do
    # This page requires at least user privileges.
    redirect '/author/news' unless login?
    # Display view.
    slim :author_news_new
  end
  
  ##
  # Create news item sequence of dashboard for author/admin/super users.
  post '/author/news/create' do
    # This page requires at least user privileges.
    redirect '/author/news' unless login?
    # Create new feed model object.
    @feed = Feed.new(title: params['title'], author: login_username, content: params['content'])
    # Save the new feed model object.
    @feed.save!
    # Redirect user back to dashbaord.
    redirect '/author/news'
  end
  
  ##
  # Edit news item page of dashboard for author/admin/super users.
  get '/author/news/edit/:id' do
    # This page requires at least user privileges.
    redirect '/author/home' unless login?
    # Retrieve post object by ID from DB.
    @item = Feed.find_by(id: params['id'])
    # Check if user owns the post or has admin powers.
    redirect '/author/news' unless @item.author == login_username or login_admin? or login_super?
    # Display view.
    slim :author_news_edit
  end
  
  ##
  # Create news item sequence of dashboard for author/admin/super users.
  post '/author/news/edit/:id' do
    # This page requires at least user privileges.
    redirect '/author/news' unless login?
    # Retrieve post object by ID from DB.
    @feed = Feed.find_by(id: params[:id])
    # Check if user owns the post or has admin powers.
    redirect '/author/news' unless @feed.author == login_username or login_admin? or login_super?
    # Edit the selected feed model object.
    @feed.title = params['title']
    @feed.content = params['content']
    # Save the selected feed model object.
    @feed.save!
    # Redirect user back to dashbaord.
    redirect '/author/news'
  end
  
  ##
  # Delete news item sequence for author/admin/super users.
  get '/author/news/delete/:id' do
    # This page requires at least user privileges.
    redirect '/author/home' unless login?
    # Retrieve post object by ID from DB.
    @item = Feed.find_by(id: params['id'])
    # Check if user owns the post or has admin powers.
    redirect '/author/news' unless @item.author == login_username or login_admin? or login_super?
    # Delete the feed object.
    @item.destroy
    # Redirect back to news page of dashboard.
    redirect '/author/news'
  end
  
  ##
  # Articles page of dashboard for author/admin/super users.
  get '/author/articles' do
    # This page requires at least user privileges.
    redirect '/author/home' unless login?
    # Fetch all articles.
    @articles = Article.all.order(:id)
    # Display view.
    slim :author_articles
  end
  
  ##
  # Create article page of dashboard for author/admin/super users.
  get '/author/articles/create' do
    # This page requires at least user privileges.
    redirect '/author/articles' unless login?
    # Display view.
    slim :author_articles_new
  end
  
  ##
  # Create article sequence of dashboard for author/admin/super users.
  post '/author/articles/create' do
    # This page requires at least user privileges.
    redirect '/author/articles' unless login?
    # Create new feed model object.
    @article = Article.create(title: params['title'], author: login_username, content: params['content'])
    # Save the new feed model object.
    @article.save!
    # Redirect user back to dashbaord.
    redirect '/author/articles'
  end
  
  ##
  # Edit article page of dashboard for author/admin/super users.
  get '/author/articles/edit/:id' do
    # This page requires at least user privileges.
    redirect '/author/home' unless login?
    # Retrieve post object by ID from DB.
    @item = Article.find_by(id: params['id'])
    # Check if user owns the post or has admin powers.
    redirect '/author/articles' unless @item.author == login_username or login_admin? or login_super?
    # Display view.
    slim :author_articles_edit
  end
  
  ##
  # Create article sequence of dashboard for author/admin/super users.
  post '/author/articles/edit/:id' do
    # This page requires at least user privileges.
    redirect '/author/articles' unless login?
    # Retrieve post object by ID from DB.
    @article = Article.find_by(id: params[:id])
    # Check if user owns the post or has admin powers.
    redirect '/author/articles' unless @article.author == login_username or login_admin? or login_super?
    # Edit the selected feed model object.
    @article.title = params['title']
    @article.content = params['content']
    # Save the selected feed model object.
      @article.save!
    # Redirect user back to dashbaord.
    redirect '/author/articles'
  end
  
  ##
  # Delete article sequence for author/admin/super users.
  get '/author/articles/delete/:id' do
    # This page requires at least user privileges.
    redirect '/author/home' unless login?
    # Retrieve post object by ID from DB.
    @item = Article.find_by(id: params['id'])
    # Check if user owns the post or has admin powers.
    redirect '/author/articles' unless @item.author == login_username or login_admin? or login_super?
    # Delete the feed object.
    @item.destroy
    # Redirect back to news page of dashboard.
    redirect '/author/articles'
  end
  
  ##
  # Resources page of dashboard for author/admin/super users.
  get '/author/resources' do
    # This page requires at least user privileges.
    redirect '/author/home' unless login?
    # Fetch all articles.
    @resources = Resource.all.order(:id)
    # Display view.
    slim :author_resources
  end
  
  ##
  # Create resource sequence of dashboard for author/admin/super users.
  post '/author/resources/create' do
    # This page requires at least user privileges.
    redirect '/author/resources' unless login?
    # Create new resource object.
    @resource = Resource.create(title: params['title'], author: login_username, url: params['hyperlink'], description: params['description'])
    # Save the new resource object.
    @resource.save!
    # Redirect user back to dashbaord.
    redirect '/author/resources'
  end
  
  ##
  # Create resource sequence of dashboard for author/admin/super users.
  post '/author/resources/edit/:id' do
    # This page requires at least user privileges.
    redirect '/author/resources' unless login?
    # Retrieve resource object by ID from DB.
    @resource = Resource.find_by(id: params[:id])
    # Check if user owns the resource or has admin powers.
    redirect '/author/resources' unless @resource.author == login_username or login_admin? or login_super?
    # Edit the selected resource object.
    @resource.title = params['title']
    @resource.url = params['hyperlink']
    @resource.description = params['description']
    # Save the selected resource object.
    @resource.save!
    # Redirect user back to dashbaord.
    redirect '/author/resources'
  end
  
  ##
  # Delete resource sequence for author/admin/super users.
  get '/author/resources/delete/:id' do
    # This page requires at least user privileges.
    redirect '/author/home' unless login?
    # Retrieve post object by ID from DB.
    @item = Resource.find_by(id: params['id'])
    # Check if user owns the resource or has admin powers.
    redirect '/author/resources' unless @item.author == login_username or login_admin? or login_super?
    # Delete the resource object.
    @item.destroy
    # Redirect back to news page of dashboard.
    redirect '/author/resources'
  end
  
  ##
  # Videos page of dashboard for author/admin/super users.
  get '/author/videos' do
    # This page requires at least user privileges.
    redirect '/author/home' unless login?
    # Fetch all videos.
    @videos = Video.all.order(:id)
    # Display view.
    slim :author_videos
  end
  
  ##
  # Create video link sequence of dashboard for author/admin/super users.
  post '/author/videos/create' do
    # This page requires at least user privileges.
    redirect '/author/videos' unless login?
    # Create new video link object.
    @video = Video.create(title: params['title'], author: login_username, uri: params['uri'], host: params['host'], description: params['description'])
    # Save the new video link object.
    @video.save!
    # Redirect user back to dashbaord.
    redirect '/author/videos'
  end
  
  ##
  # Create video link sequence of dashboard for author/admin/super users.
  post '/author/videos/edit/:id' do
    # This page requires at least user privileges.
    redirect '/author/videos' unless login?
    # Retrieve resource object by ID from DB.
    @video = Video.find_by(id: params[:id])
    # Check if user owns the video link or has admin powers.
    redirect '/author/videos' unless @video.author == login_username or login_admin? or login_super?
    # Edit the selected video link object.
    @video.title = params['title']
    @video.uri = params['uri']
    @video.host = params['host']
    @video.description = params['description']
    # Save the selected video link object.
    @video.save!
    # Redirect user back to dashbaord.
    redirect '/author/videos'
  end
  
  ##
  # Delete video link sequence for author/admin/super users.
  get '/author/videos/delete/:id' do
    # This page requires at least user privileges.
    redirect '/author/home' unless login?
    # Retrieve video link object by ID from DB.
    @video = Video.find_by(id: params['id'])
    # Check if user owns the video link or has admin powers.
    redirect '/author/videos' unless @video.author == login_username or login_admin? or login_super?
    # Delete the video link object.
    @video.destroy
    # Redirect back to news page of dashboard.
    redirect '/author/videos'
  end
  
  ##
  # Login for author/admin/super users.
  get '/sso/author/login' do
    # Check if user is already logged in.
    redirect '/author/home' if is_logged_in?
    # Display view.
    slim :author_login
  end
  
  ##
  # SSO Login processor for author/admin/super users.
  post '/sso/author/login' do
    # Check if user is already logged in.
    redirect '/author/home' if is_logged_in?
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
end