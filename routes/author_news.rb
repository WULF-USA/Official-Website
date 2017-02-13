require 'sinatra'
require_relative '../lib/home'
require_relative '../jobs/model_delete'
require_relative '../jobs/model_edit'
require_relative '../jobs/model_create'

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
                    # Push to background job.
                    flash[:pid] = Jobs::Models::Create.create(
                      model_type: 'Feed',
                      args: {
                        'title' => params['title'],
                        'author' => login_username,
                        'content' => params['content']
                      })
                    # Redirect user back to dashbaord.
                    redirect "/#{locale?}/author/news"
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
                    # Push to background job.
                    flash[:pid] = Jobs::Models::Edit.create(
                      model_type: 'Feed',
                      model_id: params['id'],
                      args: {
                        'title' => params['title'],
                        'content' => params['content']
                      },
                      user_id: login_username,
                      is_super: login_admin?)
                    # Redirect user back to dashbaord.
                    redirect "/#{locale?}/author/news"
                  end
                  
                  ##
                  # Delete news item sequence for author/admin/super users.
                  app.post '/author/news/delete/:id' do
                    author_login!
                    # Push to background job.
                    flash[:pid] = Jobs::Models::Delete.create(
                      model_type: 'Feed',
                      model_id: params['id'],
                      user_id: login_username,
                      is_super: login_admin?)
                    # Redirect back to news page of dashboard.
                    redirect "/#{locale?}/author/news"
                  end
            end
        end
    end
end