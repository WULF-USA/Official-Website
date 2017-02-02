require 'sinatra'

module Helpers
    module Internationalization
        def locale?
          return params[:locale] || R18n::I18n.default
        end
        def set_locale!
            session[:locale] = params[:locale] || R18n::I18n.default
        end
    end
end