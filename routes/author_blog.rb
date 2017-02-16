require 'sinatra'
require_relative '../lib/home'
require_relative '../jobs/model_delete'
require_relative '../jobs/model_edit'
require_relative '../jobs/model_create'

module Routing
    module Author
        module Blog
            def self.registered(app)
                  ##
                  # Locale redirector
                  app.get '/author/articles' do
                      forward_notifications!
                      redirect "/#{locale?}/author/articles"
                  end
                  ##
                  # Articles page of dashboard for author/admin/super users.
                  app.get '/:locale/author/articles' do
                    # Set locale
                    set_locale!
                    author_login!
                    # Fetch all articles.
                    @articles = Article.all.order(:id)
                    # Display view.
                    slim :author_articles
                  end
                  ##
                  # Locale redirector
                  app.get '/author/articles/create' do
                      forward_notifications!
                      redirect "/#{locale?}/author/articles/create"
                  end
                  ##
                  # Create article page of dashboard for author/admin/super users.
                  app.get '/:locale/author/articles/create' do
                    # Set locale
                    set_locale!
                    author_login!
                    # Display view.
                    slim :author_articles_new
                  end
                  
                  ##
                  # Create article sequence of dashboard for author/admin/super users.
                  app.post '/author/articles/create' do
                    # This page requires at least user privileges.
                    author_login!
                    # Push to background job.
                    flash[:pid] = Jobs::Models::Create.create(
                      model_type: 'Article',
                      args: {
                        'title' => params['title'],
                        'author' => login_username,
                        'content' => params['content']
                      },
                      lang: locale?)
                    # Redirect user back to dashbaord.
                    redirect "/#{locale?}/author/articles"
                  end
                  ##
                  # Locale redirector
                  app.get '/author/articles/edit/:id' do
                      forward_notifications!
                      redirect "/#{locale?}/author/articles/#{params[:id]}"
                  end
                  ##
                  # Edit article page of dashboard for author/admin/super users.
                  app.get '/:locale/author/articles/edit/:id' do
                    # Set locale
                    set_locale!
                    author_login!
                    begin
                      # Retrieve post object by ID from DB.
                      @item = Article.find_by(id: params['id'])
                    rescue ActiveRecord::RecordNotFound
                      flash[:error] = t.notifications.recmiss
                      redirect "/#{locale?}/author/articles"
                    end
                    # Check if user owns the post or has admin powers.
                    check_ownership!(@item.author)
                    # Display view.
                    slim :author_articles_edit
                  end
                  
                  ##
                  # Create article sequence of dashboard for author/admin/super users.
                  app.post '/author/articles/edit/:id' do
                    # This page requires at least user privileges.
                    author_login!
                    # Push to background job.
                    flash[:pid] = Jobs::Models::Edit.create(
                      model_type: 'Article',
                      model_id: params['id'],
                      args: {
                        'title' => params['title'],
                        'content' => params['content']
                      },
                      user_id: login_username,
                      is_super: login_admin?,
                      lang: locale?)
                    # Redirect user back to dashbaord.
                    redirect "/#{locale?}/author/articles"
                  end
                  
                  ##
                  # Delete article sequence for author/admin/super users.
                  app.post '/author/articles/delete/:id' do
                    # This page requires at least user privileges.
                    author_login!
                    # Push to background job.
                    flash[:pid] = Jobs::Models::Delete.create(
                      model_type: 'Article',
                      model_id: params['id'],
                      user_id: login_username,
                      is_super: login_admin?,
                      lang: locale?)
                    # Redirect back to news page of dashboard.
                    redirect "/#{locale?}/author/articles"
                  end
            end
        end
    end
end