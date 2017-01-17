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
    def test_login_static
        get '/sso/author/login'
        assert last_response.ok?
    end
    
    # Test logout sequence.
    def test_logout_static
        get '/sso/author/logout'
        assert last_response.redirect?
    end
    
    # Test basic blog posting abilities.
    def test_blog_basic
        title1 = 'Test title'
        content1 = 'Test content post.'
        title2 = 'Test title test 2'
        content2 = 'Test content post test 2.'
        wrapper_blog_api(title1, content1, title2, content2)
    end
    
    # Test blog posting abilities with odd inputs.
    def test_blog_adv
        title1 = '`@#$%^&*(){}|:"<>?'
        content1 = "',.;[]*-+"
        title2 = '&copy;'
        content2 = 'Test content'
        wrapper_blog_api(title1, content1, title2, content2)
    end
    
    # Test basic news posting abilities.
    def test_news_basic
        title1 = 'Test title'
        content1 = 'Test content post.'
        title2 = 'Test title test 2'
        content2 = 'Test content post test 2.'
        wrapper_news_api(title1, content1, title2, content2)
    end
    
    # Test news posting abilities with odd inputs.
    def test_news_adv
        title1 = '`@#$%^&*(){}|:"<>?'
        content1 = "',.;[]*-+"
        title2 = '&copy;'
        content2 = 'Test content'
        wrapper_news_api(title1, content1, title2, content2)
    end
end