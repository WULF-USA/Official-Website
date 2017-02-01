require 'sinatra'

module Routing
    module Author
        module Users
            def self.registered(app)
                  ##
                  # Locale redirector
                  app.get '/author/users' do
                      redirect "/#{R18::I18n.default}/author/users"
                  end
                  ##
                  # Users page of dashboard for admin/super users.
                  app.get '/:locale/author/users' do
                    # This page requires at least admin privileges.
                    redirect '/author/home' unless login_admin?
                    # Fetch all user accounts.
                    @users = Account.all.order(:id)
                    # Display view.
                    slim :author_users
                  end
            end
        end
    end
end