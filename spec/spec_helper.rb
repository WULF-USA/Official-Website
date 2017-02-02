require 'capybara/dsl'
require 'capybara/poltergeist'
require 'simplecov'
require_relative '../wulf_app.rb'

SimpleCov.start

Capybara.default_driver = :poltergeist
Capybara.app = proc { |env| WulfApp.new.call(env) }

RSpec.configure do |config|
  config.include Capybara::DSL
end

def sso_super_login
    # Log in
    visit "/en/sso/author/login"
    fill_in 'Username', with: 'testuser'
    fill_in 'Password', with: 'testpassword'
    click_on 'Sign in'
    expect(page).to have_current_path "/en/author/home"
end

def sso_super_logout
    # Log out
    click_on "Log Out"
    expect(page).to have_no_content 'Log Out'
    visit "/en/author/home"
    expect(page).to have_current_path "/en/sso/author/login"
end