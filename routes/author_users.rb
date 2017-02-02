require 'sinatra'

module Routing
    module Author
        module Users
            def self.registered(app)
                  ##
                  # Locale redirector
                  app.get '/author/users' do
                      redirect "/#{locale?}/author/users"
                  end
                  ##
                  # Users page of dashboard for admin/super users.
                  app.get '/:locale/author/users' do
                    # Set locale
                    set_locale!
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