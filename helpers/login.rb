require 'sinatra'

module Helpers
    module Login
        def login?
          #return true if is_ci?
          return (!session[:auth].nil? and (session[:auth] == true))
        end
        
        def author_login!
          if !login?
            flash[:error] = t.notifications.noauth
            redirect '/sso/author/login'
          end
        end
      
        def login_admin?
          #return true if is_ci?
          return (!session[:auth_admin].nil? and (session[:auth_admin] == true))
        end
        
        def admin_login!
          if !login_admin?
            flash[:error] = t.notifications.permissions
            redirect '/author/home'
          end
        end
      
        def login_super?
          #return true if is_ci?
          return (!session[:auth_super].nil? and (session[:auth_super] == true))
        end
        
        def is_logged_in?
          #return true if is_ci?
          return (login? or login_admin? or login_super?)
        end
        
        def is_ci?
          return (ENV['CI'] == 'true')
        end
        
        def login_username
          return Nil unless is_logged_in?
          return session[:auth_uname] unless login_super?
          return 'super'
        end
        
        def check_ownership?(owner)
          return (owner == login_username or login_admin? or login_super?)
        end
        
        def check_ownership!(owner)
          if !check_ownership?(owner)
            flash[:error] = t.notifications.permissions
            redirect '/author/home'
          end
        end
    end
end