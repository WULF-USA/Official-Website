require 'sinatra'

module Routing
    module News
        def self.registered(app)
            ##
            # Locale redirector
            app.get '/news/:id' do
                forward_notifications!
                redirect "/#{locale?}/news/#{params[:id]}"
            end
            ##
            # News item page of site.
            app.get '/:locale/news/:id' do
                # Set locale
                set_locale!
                # Retrieve post object by ID from DB.
                @item = Feed.find_by(id: params['id'])
                # Request is about to go through, register the visit with the tracker.
                tick_url(request.path_info)
                # Display view.
                slim :news_item
            end
        end
    end
end