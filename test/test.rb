require_relative "test_helper"
require "test/unit"
require 'rack/test'
require_relative '../frontend/main'

class TestVersion < Test::Unit::TestCase
    include Rack::Test::Methods
  
    # Initialize testing objects.
    def app
        Sinatra::Application
    end
    
    # Test static pages.
    def test_homepage
        get '/'
        assert last_response.ok?
    end
    
    # Test login page.
    def test_homepage
        get '/sso/author/login'
        assert last_response.ok?
    end
    
    # Test logout sequence.
    def test_homepage
        get '/sso/author/logout'
        assert last_response.redirect?
    end
end