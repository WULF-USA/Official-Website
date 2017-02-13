require 'sinatra'

module Helpers
    module Notifications
        ##
        # Forwards notifications to next HTTP request.
        def forward_notifications!
          flash.keep
        end
    end
end