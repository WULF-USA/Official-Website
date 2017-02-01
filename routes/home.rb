require 'sinatra'

module Routing
    module Home
        def self.registered(app)
              ##
              # Locale redirector
              app.get '/' do
                  redirect "/#{R18n::I18n.default}/"
              end
              ##
              # Index page of site.
              app.get '/:locale/' do
                # Retrieve all news listings.
                @feeds = Feed.all.order(created_at: :desc).limit(4)
                # Retrieve all blog posts.
                @posts = Article.all.order(created_at: :desc).limit(5)
                # Retrieve all video link listings.
                @videos = Video.all.order(created_at: :desc).limit(3)
                # Request is about to go through, register the visit with the tracker.
                tick_url(request.path_info)
                # Display view.
                slim :index
              end
        end
    end
end