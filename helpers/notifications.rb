require 'sinatra'

module Helpers
    module Notifications
        def forward_notifications!
          flash.keep
        end
    end
end