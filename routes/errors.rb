require 'sinatra'

module Routing
    module Errors
        def self.registered(app)
              ##
              # Catch-all 404 error handler.
              app.not_found do
                # Request is about to go through, register the visit with the tracker.
                tick_url(request.path_info)
                # Display view.
                slim :not_found
              end
        end
    end
end