require 'sinatra'

module Routing
    module Videos
        def self.registered(app)
              ##
              # Blog listing of site.
              app.get '/videos' do
                # Retrieve all video link posts.
                @videos = Video.all.order(created_at: :desc)
                # Request is about to go through, register the visit with the tracker.
                tick_url(request.path_info)
                # Display View
                slim :video_list
              end
        end
    end
end