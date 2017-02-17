require 'sinatra'
require_relative '../lib/home'
require_relative '../jobs/model_delete'
require_relative '../jobs/model_edit'
require_relative '../jobs/model_create'

module Routing
    module Author
        module Videos
            def self.registered(app)
                  ##
                  # Locale redirector
                  app.get '/author/videos' do
                      forward_notifications!
                      redirect "/#{locale?}/author/videos"
                  end
                  ##
                  # Videos page of dashboard for author/admin/super users.
                  app.get '/:locale/author/videos' do
                    # Set locale
                    set_locale!
                    # This page requires at least user privileges.
                    author_login!
                    # Fetch all videos.
                    @videos = Video.all.order(:id)
                    # Display view.
                    slim :author_videos
                  end
                  
                  ##
                  # Create video link sequence of dashboard for author/admin/super users.
                  app.post '/author/videos/create' do
                    # This page requires at least user privileges.
                    author_login!
                    flash[:pid] = Jobs::Models::Create.create(
                      model_type: 'Video',
                      args: {
                        'title' => params['title'],
                        'author' => login_username,
                        'uri' => params['uri'],
                        'host' => params['host'],
                        'description' => params['description']
                      },
                      lang: locale?)
                    # Redirect user back to dashbaord.
                    redirect "/#{locale?}/author/videos"
                  end
                  
                  ##
                  # Create video link sequence of dashboard for author/admin/super users.
                  app.post '/author/videos/edit/:id' do
                    # This page requires at least user privileges.
                    author_login!
                    # Push to background job.
                    flash[:pid] = Jobs::Models::Edit.create(
                      model_type: 'Video',
                      model_id: params['id'],
                      args: {
                        'title' => params['title'],
                        'uri' => params['uri'],
                        'host' => params['host'],
                        'description' => params['description']
                      },
                      lang: locale?,
                      user_id: login_username,
                      is_super: login_admin?)
                    # Redirect user back to dashbaord.
                    redirect "/#{locale?}/author/videos"
                  end
                  
                  ##
                  # Delete video link sequence for author/admin/super users.
                  app.post '/author/videos/delete/:id' do
                    # This page requires at least user privileges.
                    author_login!
                    # Push to background job.
                    flash[:pid] = Jobs::Models::Delete.create(
                      model_type: 'Video',
                      model_id: params['id'],
                      user_id: login_username,
                      lang: locale?,
                      is_super: login_admin?)
                    # Redirect back to news page of dashboard.
                    redirect "/#{locale?}/author/videos"
                  end
            end
        end
    end
end