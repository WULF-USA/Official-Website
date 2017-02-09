require 'sinatra'
require_relative '../lib/home'
require_relative '../lib/home_data'

module Routing
    module Home
        def self.registered(app)
              ##
              # Locale redirector
              app.get '/' do
                  forward_notifications!
                  redirect "/#{locale?}/"
              end
              ##
              # Index page of site.
              app.get '/:locale/' do
                # Set locale
                set_locale!
                # Retrieve all news listings.
                @data = Lib::Cache::Home.get_metadata
                # Request is about to go through, register the visit with the tracker.
                tick_url(request.path_info)
                # Display view.
                slim :index
              end
        end
    end
end