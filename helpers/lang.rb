require 'sinatra'

module Helpers
    module Internationalization
        def locale?
          return params[:locale]
        end
    end
end