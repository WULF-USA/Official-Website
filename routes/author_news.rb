require 'sinatra'

module Routing
    module Author
        module News
            def self.registered(app)
                  ##
                  # Locale redirector
                  app.get '/author/news' do
                      redirect "/#{locale?}/author/news"
                  end
                  ##
                  # News page of dashboard for author/admin/super users.
                  app.get '/:locale/author/news' do
                    # Set locale
                    set_locale!
                    # This page requires at least user privileges.
                    redirect '/author/home' unless login?
                    # Fetch all user accounts.
                    @feeds = Feed.all.order(:id)
                    # Display view.
                    slim :author_news
                  end
                  ##
                  # Locale redirector
                  app.get '/author/news/create' do
                      redirect "/#{locale?}/author/news/create"
                  end
                  ##
                  # Create news item page of dashboard for author/admin/super users.
                  app.get '/:locale/author/news/create' do
                    # Set locale
                    set_locale!
                    # This page requires at least user privileges.
                    redirect '/author/news' unless login?
                    # Display view.
                    slim :author_news_new
                  end
                  
                  ##
                  # Create news item sequence of dashboard for author/admin/super users.
                  app.post '/author/news/create' do
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
                  # Locale redirector
                  app.get '/author/news/edit/:id' do
                      redirect "/#{locale?}/author/news/edit/#{params[:id]}"
                  end
                  ##
                  # Edit news item page of dashboard for author/admin/super users.
                  app.get '/:locale/author/news/edit/:id' do
                    # Set locale
                    set_locale!
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
                  app.post '/author/news/edit/:id' do
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
                  app.post '/author/news/delete/:id' do
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
            end
        end
    end
end