require 'sinatra'

module Routing
    module Author
        module Home
            def self.registered(app)
                  ##
                  # Dashboard home page for author/admin/super users.
                  app.get '/author/home' do
                    # This page requires at least user privileges.
                    redirect '/sso/author/login' unless login?
                    # Display view.
                    slim :author_home
                  end
            end
        end
    end
end