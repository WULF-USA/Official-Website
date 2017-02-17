require 'sinatra'

module Helpers
    module Internationalization
        ##
        # Returns currently selected locale.
        def locale?
          return session[:locale] || R18n::I18n.default
        end
        
        ##
        # Sets the locale based on params hash.
        def set_locale!
            if params[:locale] != 'author'
                session[:locale] = params[:locale] || R18n::I18n.default
            end
            R18n.set(session[:locale])
        end
    end
end