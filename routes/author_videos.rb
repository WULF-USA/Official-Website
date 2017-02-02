require 'sinatra'

module Routing
    module Author
        module Videos
            def self.registered(app)
                  ##
                  # Locale redirector
                  app.get '/author/videos' do
                      redirect "/#{locale?}/author/videos"
                  end
                  ##
                  # Videos page of dashboard for author/admin/super users.
                  app.get '/:locale/author/videos' do
                    # Set locale
                    set_locale!
                    # This page requires at least user privileges.
                    redirect '/author/home' unless login?
                    # Fetch all videos.
                    @videos = Video.all.order(:id)
                    # Display view.
                    slim :author_videos
                  end
                  
                  ##
                  # Create video link sequence of dashboard for author/admin/super users.
                  app.post '/author/videos/create' do
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
                  app.post '/author/videos/edit/:id' do
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
                  app.get '/author/videos/delete/:id' do
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
            end
        end
    end
end