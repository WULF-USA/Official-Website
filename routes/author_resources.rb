require 'sinatra'

module Routing
    module Author
        module Resources
            def self.registered(app)
                  ##
                  # Locale redirector
                  app.get '/author/resources' do
                      forward_notifications!
                      redirect "/#{locale?}/author/resources"
                  end
                  ##
                  # Resources page of dashboard for author/admin/super users.
                  app.get '/:locale/author/resources' do
                    # Set locale
                    set_locale!
                    author_login!
                    # Fetch all articles.
                    @resources = Resource.all.order(:id)
                    # Display view.
                    slim :author_resources
                  end
                  
                  ##
                  # Create resource sequence of dashboard for author/admin/super users.
                  app.post '/author/resources/create' do
                    author_login!
                    # Push to background job.
                    flash[:pid] = Jobs::Models::Create.create(
                      model_type: 'Resource',
                      args: {
                        'title' => params['title'],
                        'author' => login_username,
                        'url' => params['hyperlink'],
                        'description' => params['description']
                      })
                    # Redirect user back to dashbaord.
                    redirect "/#{locale?}/author/resources"
                  end
                  
                  ##
                  # Create resource sequence of dashboard for author/admin/super users.
                  app.post '/author/resources/edit/:id' do
                    author_login!
                    # Push to background job.
                    flash[:pid] = Jobs::Models::Edit.create(
                      model_type: 'Resource',
                      model_id: params['id'],
                      args: {
                        'title' => params['title'],
                        'url' => params['hyperlink'],
                        'description' => params['description']
                      },
                      user_id: login_username,
                      is_super: login_admin?)
                    # Redirect user back to dashbaord.
                    redirect "/#{locale?}/author/resources"
                  end
                  
                  ##
                  # Delete resource sequence for author/admin/super users.
                  app.post '/author/resources/delete/:id' do
                    author_login!
                    # Push to background job.
                    flash[:pid] = Jobs::Models::Delete.create(
                      model_type: 'Resource',
                      model_id: params['id'],
                      user_id: login_username,
                      is_super: login_admin?)
                    # Redirect back to news page of dashboard.
                    redirect "/#{locale?}/author/resources"
                  end
            end
        end
    end
end