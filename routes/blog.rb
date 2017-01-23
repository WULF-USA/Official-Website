require 'sinatra'

module Routing
    module Blog
        def self.registered(app)
            ##
            # Blog listing of site.
            app.get '/blog' do
                # Retrieve all blog posts.
                @posts = Article.all.order(created_at: :desc)
                # Request is about to go through, register the visit with the tracker.
                tick_url(request.path_info)
                # Display View
                slim :blog_list
            end
            
            ##
            # Article view page of site.
            app.get '/blog/:id' do
                # Retrieve post content.
                @post = Article.find_by(id: params[:id])
                # Request is about to go through, register the visit with the tracker.
                tick_url(request.path_info)
                # Display View.
                slim :blog_item
            end
        end
    end
end