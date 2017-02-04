require 'sinatra'

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
                    begin
                      # Save the new feed model object.
                      @article = Article.create!(title: params['title'], author: login_username, content: params['content'])
                      flash[:info] = t.notifications.savesucc(t.types.article(1))
                    rescue ActiveRecord::RecordInvalid
                      flash[:error] = t.notifications.saveerror(t.types.article(1))
                    end
                    # Redirect user back to dashbaord.
                    redirect '/author/articles'
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
                      redirect '/author/articles'
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
                    begin
                      # Retrieve post object by ID from DB.
                      @article = Article.find_by(id: params[:id])
                    rescue ActiveRecord::RecordNotFound
                      flash[:error] = t.notifications.recmiss
                      redirect '/author/articles'
                    end
                    # Check if user owns the post or has admin powers.
                    if check_ownership?(@article.author)
                      # Edit the selected feed model object.
                      @article.title = params['title']
                      @article.content = params['content']
                      # Save the selected feed model object.
                      begin
                        @article.save!
                        flash[:info] = t.notifications.savesucc(t.types.article(1))
                      rescue ActiveRecord::RecordInvalid
                        flash[:error] = t.notifications.saveerror(t.types.article(1))
                      end
                    else
                      flash[:error] = t.notifications.permissions
                    end
                    # Redirect user back to dashbaord.
                    redirect '/author/articles'
                  end
                  
                  ##
                  # Delete article sequence for author/admin/super users.
                  app.post '/author/articles/delete/:id' do
                    # This page requires at least user privileges.
                    author_login!
                    begin
                      # Retrieve post object by ID from DB.
                      @item = Article.find_by(id: params['id'])
                    rescue ActiveRecord::RecordNotFound
                      flash[:error] = t.notifications.recmiss
                      redirect '/author/articles'
                    end
                    # Check if user owns the post or has admin powers.
                    if check_ownership?(@item.author)
                      flash[:info] = t.notifications.deletesucc(t.types.article(1))
                      @item.destroy
                    else
                      flash[:error] = t.notifications.permissions
                    end
                    # Redirect back to news page of dashboard.
                    redirect '/author/articles'
                  end
            end
        end
    end
end