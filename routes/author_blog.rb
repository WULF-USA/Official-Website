require 'sinatra'

module Routing
    module Author
        module Blog
            def self.registered(app)
                  ##
                  # Locale redirector
                  app.get '/author/articles' do
                      redirect "/#{R18::I18n.default}/author/articles"
                  end
                  ##
                  # Articles page of dashboard for author/admin/super users.
                  app.get '/:locale/author/articles' do
                    # This page requires at least user privileges.
                    redirect '/author/home' unless login?
                    # Fetch all articles.
                    @articles = Article.all.order(:id)
                    # Display view.
                    slim :author_articles
                  end
                  ##
                  # Locale redirector
                  app.get '/author/articles/create' do
                      redirect "/#{R18::I18n.default}/author/articles/create"
                  end
                  ##
                  # Create article page of dashboard for author/admin/super users.
                  app.get '/:locale/author/articles/create' do
                    # This page requires at least user privileges.
                    redirect '/author/articles' unless login?
                    # Display view.
                    slim :author_articles_new
                  end
                  
                  ##
                  # Create article sequence of dashboard for author/admin/super users.
                  app.post '/author/articles/create' do
                    # This page requires at least user privileges.
                    redirect '/:locale/author/articles' unless login?
                    # Create new feed model object.
                    @article = Article.create(title: params['title'], author: login_username, content: params['content'])
                    # Save the new feed model object.
                    @article.save!
                    # Redirect user back to dashbaord.
                    redirect '/author/articles'
                  end
                  ##
                  # Locale redirector
                  app.get '/author/articles/edit/:id' do
                      redirect "/#{R18::I18n.default}/author/articles/#{params[:id]}"
                  end
                  ##
                  # Edit article page of dashboard for author/admin/super users.
                  app.get '/:locale/author/articles/edit/:id' do
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
                  app.post '/author/articles/edit/:id' do
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
                  app.get '/author/articles/delete/:id' do
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
            end
        end
    end
end