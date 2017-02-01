require 'sinatra'

module Routing
    module Author
        module Traffic
            def self.registered(app)
                  ##
                  # Locale redirector
                  app.get '/author/traffic' do
                      redirect "/#{R18::I18n.default}/author/traffic"
                  end
                  ##
                  # Traffic page of dashboard for admin/super users.
                  app.get '/:locale/author/traffic' do
                    # This page requires at least admin privileges.
                    redirect '/author/home' unless login_admin?
                    # Fetch all trackers from DB.
                    @trackers = Tracker.all.order(:visits)
                    # Display view.
                    slim :author_traffic
                  end
            end
        end
    end
end