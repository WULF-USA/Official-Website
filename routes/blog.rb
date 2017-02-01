require 'sinatra'

module Routing
    module Blog
        def self.registered(app)
            ##
            # Locale redirector
            app.get '/blog' do
                redirect "/#{R18::I18n.default}/blog"
            end
            ##
            # Blog listing of site.
            app.get '/:locale/blog' do
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
                redirect "/#{R18::I18n.default}/blog/#{params[:id]}"
            end
            ##
            # Article view page of site.
            app.get '/:locale/blog/:id' do
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