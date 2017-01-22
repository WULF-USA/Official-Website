require 'sinatra'

module Routing
    module Author
        module Users
            def self.registered(app)
                  ##
                  # Users page of dashboard for admin/super users.
                  app.get '/author/users' do
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