require 'sinatra'
require 'securerandom'

module Routing
    module SSO
        def self.registered(app)
              ##
              # Locale redirector
              app.get '/sso/author/login' do
                  redirect "/#{R18::I18n.default}/sso/author/login"
              end
              ##
              # Login for author/admin/super users.
              app.get '/:locale/sso/author/login' do
                # Check if user is already logged in.
                redirect '/author/home' if is_logged_in?
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
                  redirect '/sso/author/login'
                end
                
                # First check for super user
                if uname == ENV['APP_SUPER_UNAME'] and pass == ENV['APP_SUPER_PASSWD']
                  # Success. Modify session cookies.
                  session[:auth] = true
                  session[:auth_admin] = true
                  session[:auth_super] = true
                  session[:auth_uname] = 'super'
                  # Redirect to dashboard.
                  redirect '/author/home'
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
                    # Redirect to dashboard.
                    redirect '/author/home'
                    return
                  end
                rescue
                  # Do nothing, account not found.
                end
                
                # Invalid login credentials. Redirect to log in page.
                redirect '/sso/author/login'
              end
              
              ##
              # SSO Log out processor for author/admin/super users.
              app.get '/sso/author/logout' do
                # Reset all session cookies.
                session[:auth] = false
                session[:auth_admin] = false
                session[:auth_super] = false
                session[:auth_uname] = nil
                # Redirect to home page.
                redirect '/'
              end
              
              ##
              # SSO Account modifier for deleting accounts.
              app.post '/sso/author/remove/:uname' do
                # This page requires at least administrator privileges.
                redirect '/author/home' unless login_admin?
                begin
                  # Find user account by username.
                  acc = Account.find_by(username: params['uname'])
                  # Destroy the account.
                  acc.destroy
                rescue
                  # User does not exist.
                end
                # Redirect to users dashboard page.
                redirect '/author/users'
              end
              
              ##
              # SSO Account modifier for updating passwords.
              app.post '/sso/author/pass/:uname' do
                # This page requires at least adminstrator privileges.
                redirect '/author/home' unless login_admin?
                begin
                  # Find user account by username.
                  acc = Account.find_by(username: params['uname'])
                  # Update password value (Hashing done by ActiveRecord model object).
                  acc.password = params['newpassword']
                  # Save new model object state to DB.
                  acc.save!
                rescue
                  # User does not exist or some kind of save error occured.
                end
                # Redirect to users dashboard page.
                redirect '/author/users'
              end
              
              ##
              # SSO Account modifier for creating new accounts.
              app.post '/sso/author/new' do
                # This page requires at least administrator privileges.
                redirect '/author/home' unless login_admin?
                begin
                  # Create new Account model object.
                  acc = Account.new()
                  # Fill in all needed values.
                  acc.username = params['username']
                  acc.password = params['password']
                  if params['type'] == 'admin'
                    acc.is_super = true
                  else
                    acc.is_super = false
                  end
                  # Save new model object to DB.
                  acc.save!
                rescue
                  # User does not exist or some kind of save error occured.
                end
                # Redirect to users dashboard page.
                redirect '/author/users'
              end
        end
    end
end