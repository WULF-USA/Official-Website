require 'sinatra'

module Routing
    module About
        def self.registered(app)
              ##
              # Locale redirector
              app.get '/about' do
                  forward_notifications!
                  redirect "/#{locale?}/about"
              end
              ##
              # About page of site.
              app.get '/:locale/about' do
                # Set locale
                set_locale!
                # Request is about to go through, register the visit with the tracker.
                tick_url(request.path_info)
                # Display view.
                slim :about
              end
        end
    end
end