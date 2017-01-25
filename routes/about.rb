require 'sinatra'

module Routing
    module About
        def self.registered(app)
              ##
              # About page of site.
              app.get '/about' do
                # Request is about to go through, register the visit with the tracker.
                tick_url(request.path_info)
                # Display view.
                slim :about
              end
        end
    end
end