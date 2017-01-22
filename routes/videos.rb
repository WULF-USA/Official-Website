require 'sinatra'

module Routing
    module Videos
        def self.registered(app)
              ##
              # Blog listing of site.
              app.get '/videos' do
                # Retrieve all video link posts.
                @videos = Video.all.order(created_at: :desc)
                # Display View
                slim :video_list
              end
        end
    end
end