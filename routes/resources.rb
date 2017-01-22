require 'sinatra'

module Routing
    module Resources
        def self.registered(app)
              ##
              # Resources listing of site.
              app.get '/resources' do
                # Retrieve resource list.
                @resources = Resource.all.order(title: :asc)
                # Display view.
                slim :resource_list
              end
        end
    end
end