require 'capybara/dsl'
require 'capybara/poltergeist'
require 'rspec-benchmark'
require 'simplecov'
SimpleCov.start
require_relative '../wulf_app.rb'

Capybara.default_driver = :poltergeist
if ENV['TEST_TYPE'] == 'performance'
  Capybara.app_host = 'http://localhost:8080'
  Capybara.run_server = false
else
  Capybara.app = proc { |env| WulfApp.new.call(env) }
  Resque.inline = true
end

options = {js_errors: false}
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, options)
end

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include RSpec::Benchmark::Matchers
  config.after(:each) do
    page.driver.clear_cookies
  end
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