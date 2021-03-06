require 'sinatra'

module Routing
    module Author
        module Traffic
            def self.registered(app)
                  ##
                  # Locale redirector
                  app.get '/author/traffic' do
                      forward_notifications!
                      redirect "/#{locale?}/author/traffic"
                  end
                  ##
                  # Traffic page of dashboard for admin/super users.
                  app.get '/:locale/author/traffic' do
                    # Set locale
                    set_locale!
                    # This page requires at least admin privileges.
                    author_login!
                    # Fetch all trackers from DB.
                    @trackers = Tracker.all.order(:visits)
                    # Display view.
                    slim :author_traffic
                  end
            end
        end
    end
end