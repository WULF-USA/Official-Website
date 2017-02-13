require 'sinatra'

module Helpers
    module Internationalization
        ##
        # Returns currently selected locale.
        def locale?
          return params[:locale] || R18n::I18n.default
        end
        
        ##
        # Sets the locale based on params hash.
        def set_locale!
            session[:locale] = params[:locale] || R18n::I18n.default
            R18n.set(session[:locale])
        end
    end
end