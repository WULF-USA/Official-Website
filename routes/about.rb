require 'sinatra'

module Routing
    module About
        def self.registered(app)
              ##
              # About page of site.
              app.get '/about' do
                # Display view.
                slim :about
              end
        end
    end
end