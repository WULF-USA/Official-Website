require 'sinatra'

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
                    begin
                      @video = Video.create!(title: params['title'], author: login_username, uri: params['uri'], host: params['host'], description: params['description'])
                      flash[:info] = t.notifications.savesucc(t.types.video(1))
                    rescue ActiveRecord::RecordInvalid
                      flash[:error] = t.notifications.saveerror(t.types.video(1))
                    end
                    # Redirect user back to dashbaord.
                    redirect '/author/videos'
                  end
                  
                  ##
                  # Create video link sequence of dashboard for author/admin/super users.
                  app.post '/author/videos/edit/:id' do
                    # This page requires at least user privileges.
                    author_login!
                    begin
                      # Retrieve resource object by ID from DB.
                      @video = Video.find_by(id: params[:id])
                    rescue
                      flash[:error] = t.notifications.recmiss
                      redirect '/author/videos'
                    end
                    # Check if user owns the video link or has admin powers.
                    if check_ownership?(@video.author)
                      # Edit the selected video link object.
                      @video.title = params['title']
                      @video.uri = params['uri']
                      @video.host = params['host']
                      @video.description = params['description']
                      begin
                        # Save the selected video link object.
                        @video.save!
                        flash[:info] = t.notifications.savesucc(t.types.video(1))
                      rescue ActiveRecord::RecordInvalid
                        flash[:error] = t.notifications.saveerror(t.types.video(1))
                      end
                    else
                      flash[:error] = t.notifications.permissions
                    end
                    # Redirect user back to dashbaord.
                    redirect '/author/videos'
                  end
                  
                  ##
                  # Delete video link sequence for author/admin/super users.
                  app.post '/author/videos/delete/:id' do
                    # This page requires at least user privileges.
                    author_login!
                    begin
                      # Retrieve video link object by ID from DB.
                      @video = Video.find_by(id: params['id'])
                    rescue
                      flash[:error] = t.notifications.recmiss
                      redirect '/author/videos'
                    end
                    # Check if user owns the video link or has admin powers.
                    if check_ownership?(@video.author)
                      # Delete the video link object.
                      @video.destroy
                      flash[:info] = t.notifications.deletesucc(t.types.video(1))
                    else
                      flash[:error] = t.notifications.permissions
                    end
                    # Redirect back to news page of dashboard.
                    redirect '/author/videos'
                  end
            end
        end
    end
end