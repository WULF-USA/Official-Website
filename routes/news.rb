require 'sinatra'

module Routing
    module News
        def self.registered(app)
            ##
            # News item page of site.
            app.get '/news/:id' do
                # Retrieve post object by ID from DB.
                @item = Feed.find_by(id: params['id'])
                # Display view.
                slim :news_item
            end
        end
    end
end