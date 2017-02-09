require 'sinatra'
require_relative '../lib/home'

module Routing
    module Author
        module News
            def self.registered(app)
                  ##
                  # Locale redirector
                  app.get '/author/news' do
                    forward_notifications!
                    redirect "/#{locale?}/author/news"
                  end
                  ##
                  # News page of dashboard for author/admin/super users.
                  app.get '/:locale/author/news' do
                    # Set locale
                    set_locale!
                    author_login!
                    # Fetch all user accounts.
                    @feeds = Feed.all.order(:id)
                    # Display view.
                    slim :author_news
                  end
                  ##
                  # Locale redirector
                  app.get '/author/news/create' do
                    forward_notifications!
                    redirect "/#{locale?}/author/news/create"
                  end
                  ##
                  # Create news item page of dashboard for author/admin/super users.
                  app.get '/:locale/author/news/create' do
                    # Set locale
                    set_locale!
                    author_login!
                    # Display view.
                    slim :author_news_new
                  end
                  
                  ##
                  # Create news item sequence of dashboard for author/admin/super users.
                  app.post '/author/news/create' do
                    author_login!
                    begin
                      @feed = Feed.create!(title: params['title'], author: login_username, content: params['content'])
                      flash[:info] = t.notifications.savesucc(t.types.news)
                      Lib::Cache::Home.invalidate!
                    rescue ActiveRecord::RecordInvalid
                      flash[:error] = t.notifications.saveerror(t.types.news)
                    end
                    # Redirect user back to dashbaord.
                    redirect '/author/news'
                  end
                  ##
                  # Locale redirector
                  app.get '/author/news/edit/:id' do
                      forward_notifications!
                      redirect "/#{locale?}/author/news/edit/#{params[:id]}"
                  end
                  ##
                  # Edit news item page of dashboard for author/admin/super users.
                  app.get '/:locale/author/news/edit/:id' do
                    # Set locale
                    set_locale!
                    author_login!
                    begin
                      # Retrieve post object by ID from DB.
                      @item = Feed.find_by(id: params['id'])
                    rescue ActiveRecord::ResourceNotFound
                      flash[:error] = t.notifications.recmiss
                      redirect '/author/news'
                    end
                    # Check if user owns the post or has admin powers.
                    check_ownership!(@item.author)
                    # Display view.
                    slim :author_news_edit
                  end
                  
                  ##
                  # Create news item sequence of dashboard for author/admin/super users.
                  app.post '/author/news/edit/:id' do
                    author_login!
                    begin
                      # Retrieve post object by ID from DB.
                      @feed = Feed.find_by(id: params[:id])
                    rescue ActiveRecord::ResourceNotFound
                      flash[:error] = t.notifications.recmiss
                      redirect '/author/news'
                    end
                    # Check if user owns the post or has admin powers.
                    if check_ownership?(@feed.author)
                      # Edit the selected feed model object.
                      @feed.title = params['title']
                      @feed.content = params['content']
                      begin
                        # Save the selected feed model object.
                        @feed.save!
                        flash[:info] = t.notifications.savesucc(t.types.news)
                        Lib::Cache::Home.invalidate!
                      rescue ActiveRecord::RecordInvalid
                        flash[:error] = t.notifications.saveerror(t.types.news)
                      end
                    else
                      flash[:error] = t.notifications.permissions
                    end
                    # Redirect user back to dashbaord.
                    redirect '/author/news'
                  end
                  
                  ##
                  # Delete news item sequence for author/admin/super users.
                  app.post '/author/news/delete/:id' do
                    author_login!
                    begin
                      # Retrieve post object by ID from DB.
                      @item = Feed.find_by(id: params['id'])
                    rescue
                      flash[:error] = t.notifications.recmiss
                      redirect '/author/news'
                    end
                    # Check if user owns the post or has admin powers.
                    if check_ownership?(@item.author)
                      flash[:info] = t.notifications.deletesucc(t.types.news)
                      @item.destroy
                      Lib::Cache::Home.invalidate!
                    else
                      flash[:error] = t.notifications.permissions
                    end
                    # Redirect back to news page of dashboard.
                    redirect '/author/news'
                  end
            end
        end
    end
end