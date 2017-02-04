require 'sinatra'

module Routing
    module Author
        module Resources
            def self.registered(app)
                  ##
                  # Locale redirector
                  app.get '/author/resources' do
                      forward_notifications!
                      redirect "/#{locale?}/author/resources"
                  end
                  ##
                  # Resources page of dashboard for author/admin/super users.
                  app.get '/:locale/author/resources' do
                    # Set locale
                    set_locale!
                    author_login!
                    # Fetch all articles.
                    @resources = Resource.all.order(:id)
                    # Display view.
                    slim :author_resources
                  end
                  
                  ##
                  # Create resource sequence of dashboard for author/admin/super users.
                  app.post '/author/resources/create' do
                    author_login!
                    begin
                      @resource = Resource.create!(title: params['title'], author: login_username, url: params['hyperlink'], description: params['description'])
                      flash[:info] = t.notifications.savesucc(t.types.resource)
                    rescue ActiveRecord::RecordInvalid
                      flash[:error] = t.notifications.saveerror(t.types.resource)
                    end
                    # Redirect user back to dashbaord.
                    redirect '/author/resources'
                  end
                  
                  ##
                  # Create resource sequence of dashboard for author/admin/super users.
                  app.post '/author/resources/edit/:id' do
                    author_login!
                    begin
                      # Retrieve resource object by ID from DB.
                      @resource = Resource.find_by(id: params[:id])
                    rescue
                      flash[:error] = t.notifications.recmiss
                      redirect '/author/resources'
                    end
                    # Check if user owns the resource or has admin powers.
                    if check_ownership?(@resource.author)
                      # Edit the selected resource object.
                      @resource.title = params['title']
                      @resource.url = params['hyperlink']
                      @resource.description = params['description']
                      begin
                        # Save the selected resource object.
                        @resource.save!
                        flash[:info] = t.notifications.savesucc(t.types.resource)
                      rescue ActiveRecord::RecordInvalid
                        flash[:error] = t.notifications.saveerror(t.types.resource)
                      end
                    else
                      flash[:error] = t.notifications.permissions
                    end
                    # Redirect user back to dashbaord.
                    redirect '/author/resources'
                  end
                  
                  ##
                  # Delete resource sequence for author/admin/super users.
                  app.post '/author/resources/delete/:id' do
                    author_login!
                    begin
                      # Retrieve post object by ID from DB.
                      @item = Resource.find_by(id: params['id'])
                    rescue
                      flash[:error] = t.notifications.recmiss
                      redirect '/author/resources'
                    end
                    # Check if user owns the resource or has admin powers.
                    if check_ownership?(@item.author)
                      # Delete the resource object.
                      @item.destroy
                      flash[:info] = t.notifications.deletesucc(t.types.resource)
                    else
                      flash[:error] = t.notifications.permissions
                    end
                    # Redirect back to news page of dashboard.
                    redirect '/author/resources'
                  end
            end
        end
    end
end