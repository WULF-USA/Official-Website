require 'sinatra'

module Routing
    module Errors
        def self.registered(app)
              ##
              # Catch-all 404 error handler.
              app.not_found do
                # Display view.
                slim :not_found
              end
        end
    end
end