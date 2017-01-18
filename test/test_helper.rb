require "simplecov"
SimpleCov.start

def wrapper_blog_api(title1, content1, title2, content2, id)
    payload1 = {:title => title1, :content => content1 }
    payload2 = {:title => title2, :content => content2 }
    wrapper_api('/blog',
                '/blog/' << id,
                '/author/articles/create',
                '/author/articles/edit/',
                '/author/articles/delete/',
                payload1,
                payload2,
                id)
end

def wrapper_news_api(title1, content1, title2, content2, id)
    payload1 = {:title => title1, :content => content1 }
    payload2 = {:title => title2, :content => content2 }
    wrapper_api('/',
                '/news/' << id,
                '/author/news/create',
                '/author/news/edit/',
                '/author/news/delete/',
                payload1,
                payload2,
                id)
end

def wrapper_resources_api(title1, hyperlink1, content1, title2, hyperlink2, content2, id)
    payload1 = {:title => title1, :hyperlink => hyperlink1, :description => content1 }
    payload2 = {:title => title2, :hyperlink => hyperlink2, :description => content2 }
    wrapper_api('/resources',
                '/resources',
                '/author/resources/create',
                '/author/resources/edit/',
                '/author/resources/delete/',
                payload1,
                payload2,
                id)
end

def wrapper_api(test_overview, test_detailed, url_create, url_edit, url_delete, payload1, payload2, id)
    # Log in to perform secured actions.
    log_in('testuser', 'testpassword')
    # Initial test.
    get test_overview
    assert last_response.ok?
    # Create post.
    post url_create, payload1
    assert last_response.redirect?
    # Test listing page.
    get test_overview
    assert last_response.ok?
    #assert last_response.body.include?(title1)
    #assert last_response.body.include?('super')
    # Test post page.
    get (test_detailed)
    assert last_response.ok?
    #assert last_response.body.include?(title1)
    #assert last_response.body.include?('super')
    #assert last_response.body.include?(content1)
    # Edit post.
    post (url_edit << id), payload2
    assert last_response.redirect?
    # Test listing page.
    get test_overview
    assert last_response.ok?
    #assert last_response.body.include?(title2)
    #assert last_response.body.include?('super')
    # Test post page.
    get (test_detailed << id)
    assert last_response.ok?
    #assert last_response.body.include?(title2)
    #assert last_response.body.include?('super')
    #assert last_response.body.include?(content2)
    # Delete post.
    get (url_delete << id)
    assert last_response.redirect?
    # Test listing page.
    get (test_overview)
    assert last_response.ok?
    #assert !last_response.body.include?(title2)
    #assert !last_response.body.include?('super')
    #assert !last_response.body.include?(content2)
    # Log out of session.
    log_out
end

def log_in(username, password)
    post '/sso/author/login', {:inputUser => username, :inputPassword => password}
end

def log_out
    get '/sso/author/logout'
end