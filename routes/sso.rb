require 'sinatra'
require 'securerandom'
require_relative '../models/accounts'

module Routing
    module SSO
        def self.registered(app)
              ##
              # Locale redirector
              app.get '/sso/author/login' do
                  forward_notifications!
                  redirect "/#{locale?}/sso/author/login"
              end
              ##
              # Login for author/admin/super users.
              app.get '/:locale/sso/author/login' do
                # Set locale
                set_locale!
                # Check if user is already logged in.
                redirect "/#{locale?}/author/home" if is_logged_in?
                # CVA-001: Protects from CSRF attack.
                session[:xs_key] = SecureRandom.urlsafe_base64(25)
                @xs_key = session[:xs_key]
                # Display view.
                slim :author_login
              end
              
              ##
              # SSO Login processor for author/admin/super users.
              app.post '/sso/author/login' do
                # Check if user is already logged in.
                redirect '/author/home' if is_logged_in?
                # Copy in parameters for sanatizing.
                uname = params['inputUser']
                pass = params['inputPassword']
              
                # CVA-001: Protects from CSRF attack.
                if(session[:xs_key] != params['xskey'])
                  session[:xs_key] = nil
                  flash[:error] = t.notifications.xsrf
                  redirect "/#{locale?}/sso/author/login"
                end
                
                # First check for super user
                if uname == ENV['APP_SUPER_UNAME'] and pass == ENV['APP_SUPER_PASSWD']
                  # Success. Modify session cookies.
                  session[:auth] = true
                  session[:auth_admin] = true
                  session[:auth_super] = true
                  session[:auth_uname] = 'super'
                  # Redirect to dashboard.
                  flash[:info] = t.notifications.loginsucc(uname)
                  redirect "/#{locale?}/author/users"
                  return
                end
              
                # Check for regular Administrator/User
                begin
                  # Search DB by username.
                  acc = Account.find_by(username: uname)
                  # Verify password hashes match.
                  if acc.password == pass
                    # Success. Modify session cookies.
                    session[:auth] = true
                    session[:auth_admin] = acc.is_super
                    session[:auth_uname] = uname
                    flash[:info] = t.notifications.loginsucc(uname)
                    # Redirect to dashboard.
                    redirect "/#{locale?}/author/home"
                    return
                  end
                rescue ActiveRecord::RecordNotFound
                  flash[:error] = t.notifications.invalidauth
                rescue NoMethodError
                  flash[:error] = t.notifications.invalidauth
                end
                
                # Invalid login credentials. Redirect to log in page.
                redirect "/#{locale?}/sso/author/login"
              end
              
              ##
              # SSO Log out processor for author/admin/super users.
              app.get '/sso/author/logout' do
                # Reset all session cookies.
                session[:auth] = false
                session[:auth_admin] = false
                session[:auth_super] = false
                session[:auth_uname] = nil
                flash[:info] = t.notifications.loggedout
                # Redirect to home page.
                redirect "/#{locale?}"
              end
              
              ##
              # SSO Account modifier for deleting accounts.
              app.post '/sso/author/remove/:uname' do
                # This page requires at least administrator privileges.
                admin_login!
                begin
                  # Find user account by username.
                  acc = Account.find_by(username: params['uname'])
                  # Destroy the account.
                  acc.destroy
                  flash[:info] = t.notifications.deletesucc('user')
                rescue ActiveRecord::RecordNotFound
                  flash[:error] = t.notifications.deleteerror('user')
                end
                # Redirect to users dashboard page.
                redirect "/#{locale?}/author/users"
              end
              
              ##
              # SSO Account modifier for updating passwords.
              app.post '/sso/author/pass/:uname' do
                # This page requires at least adminstrator privileges.
                admin_login!
                begin
                  # Find user account by username.
                  acc = Account.find_by(username: params['uname'])
                  # Update password value (Hashing done by ActiveRecord model object).
                  acc.password = params['newpassword']
                  # Save new model object state to DB.
                  acc.save!
                  flash[:info] = t.notifications.savesucc('user')
                rescue ActiveRecord::RecordNotFound
                  flash[:error] = t.notifications.saveerror('user')
                rescue ActiveRecord::RecordInvalid
                  flash[:error] = t.notifications.saveerror('user')
                end
                # Redirect to users dashboard page.
                redirect "/#{locale?}/author/users"
              end
              
              ##
              # SSO Account modifier for creating new accounts.
              app.post '/sso/author/new' do
                # This page requires at least administrator privileges.
                admin_login!
                begin
                  # Create new Account model object.
                  acc = Account.create!(username: params['username'], password: params['password'], is_super: (params['type'] == 'admin'))
                  flash[:info] = t.notifications.savesucc('user')
                rescue ActiveRecord::RecordInvalid
                  flash[:error] = t.notifications.saveerror('user')
                end
                # Redirect to users dashboard page.
                redirect "/#{locale?}/author/users"
              end
        end
    end
end