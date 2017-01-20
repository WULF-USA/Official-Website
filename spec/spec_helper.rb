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