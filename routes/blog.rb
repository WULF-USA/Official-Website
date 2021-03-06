require 'sinatra'
require 'resque-status'

module Routing
    module Blog
        def self.registered(app)
            ##
            # Locale redirector
            app.get '/blog' do
                forward_notifications!
                redirect "/#{locale?}/blog"
            end
            ##
            # Blog listing of site.
            app.get '/:locale/blog' do
                # Set locale
                set_locale!
                # Retrieve all blog posts.
                @posts = Article.all.order(created_at: :desc)
                # Request is about to go through, register the visit with the tracker.
                tick_url(request.path_info)
                # Display View
                slim :blog_list
            end
            ##
            # Locale redirector
            app.get '/blog/:id' do
                forward_notifications!
                redirect "/#{locale?}/blog/#{params[:id]}"
            end
            ##
            # Article view page of site.
            app.get '/:locale/blog/:id' do
                # Set locale
                set_locale!
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