require 'sinatra'

module Routing
    module Author
        module Resources
            def self.registered(app)
                  ##
                  # Locale redirector
                  app.get '/author/resources' do
                      redirect "/#{R18::I18n.default}/author/resources"
                  end
                  ##
                  # Resources page of dashboard for author/admin/super users.
                  app.get '/:locale/author/resources' do
                    # This page requires at least user privileges.
                    redirect '/author/home' unless login?
                    # Fetch all articles.
                    @resources = Resource.all.order(:id)
                    # Display view.
                    slim :author_resources
                  end
                  
                  ##
                  # Create resource sequence of dashboard for author/admin/super users.
                  app.post '/author/resources/create' do
                    # This page requires at least user privileges.
                    redirect '/author/resources' unless login?
                    # Create new resource object.
                    @resource = Resource.create(title: params['title'], author: login_username, url: params['hyperlink'], description: params['description'])
                    # Save the new resource object.
                    @resource.save!
                    # Redirect user back to dashbaord.
                    redirect '/author/resources'
                  end
                  
                  ##
                  # Create resource sequence of dashboard for author/admin/super users.
                  app.post '/author/resources/edit/:id' do
                    # This page requires at least user privileges.
                    redirect '/author/resources' unless login?
                    # Retrieve resource object by ID from DB.
                    @resource = Resource.find_by(id: params[:id])
                    # Check if user owns the resource or has admin powers.
                    redirect '/author/resources' unless @resource.author == login_username or login_admin? or login_super?
                    # Edit the selected resource object.
                    @resource.title = params['title']
                    @resource.url = params['hyperlink']
                    @resource.description = params['description']
                    # Save the selected resource object.
                    @resource.save!
                    # Redirect user back to dashbaord.
                    redirect '/author/resources'
                  end
                  
                  ##
                  # Delete resource sequence for author/admin/super users.
                  app.get '/author/resources/delete/:id' do
                    # This page requires at least user privileges.
                    redirect '/author/home' unless login?
                    # Retrieve post object by ID from DB.
                    @item = Resource.find_by(id: params['id'])
                    # Check if user owns the resource or has admin powers.
                    redirect '/author/resources' unless @item.author == login_username or login_admin? or login_super?
                    # Delete the resource object.
                    @item.destroy
                    # Redirect back to news page of dashboard.
                    redirect '/author/resources'
                  end
            end
        end
    end
end