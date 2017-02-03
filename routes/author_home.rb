require 'sinatra'

module Routing
    module Author
        module Home
            def self.registered(app)
                  ##
                  # Locale redirector
                  app.get '/author/home' do
                      forward_notifications!
                      redirect "/#{locale?}/author/home"
                  end
                  ##
                  # Dashboard home page for author/admin/super users.
                  app.get '/:locale/author/home' do
                    # Set locale
                    set_locale!
                    author_login!
                    # Display view.
                    slim :author_home
                  end
            end
        end
    end
end