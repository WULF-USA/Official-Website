require 'sinatra'

module Routing
    module Home
        def self.registered(app)
              ##
              # Index page of site.
              app.get '/' do
                # Retrieve all news listings.
                @feeds = Feed.all.order(created_at: :desc).limit(4)
                # Retrieve all blog posts.
                @posts = Article.all.order(created_at: :desc).limit(5)
                # Retrieve all video link listings.
                @videos = Video.all.order(created_at: :desc).limit(3)
                # Display view.
                slim :index
              end
        end
    end
end