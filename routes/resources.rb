require 'sinatra'

module Routing
    module Resources
        def self.registered(app)
              ##
              # Locale redirector
              app.get '/resources' do
                  forward_notifications!
                  redirect "/#{locale?}/resources"
              end
              ##
              # Resources listing of site.
              app.get '/:locale/resources' do
                if params[:locale] == "author"
                    forward_notifications!
                    redirect "/#{locale?}/author/resources"
                end
                # Set locale
                set_locale!
                # Retrieve resource list.
                @resources = Resource.all.order(title: :asc)
                # Request is about to go through, register the visit with the tracker.
                tick_url(request.path_info)
                # Display view.
                slim :resource_list
              end
        end
    end
end