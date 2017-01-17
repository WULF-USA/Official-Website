require "simplecov"
SimpleCov.start

def wrapper_blog_api(title1, content1, title2, content2)
    # Log in to perform secured actions.
    log_in('testuser', 'testpassword')
    # Initial test.
    get '/blog'
    assert last_response.ok?
    # Create post.
    post '/author/articles/create', {:title => title1, :content => content1}
    assert last_response.redirect?
    # Test listing page.
    get '/blog'
    assert last_response.ok?
    assert last_response.body.include?(title1)
    assert last_response.body.include?('super')
    # Test post page.
    get '/blog/1'
    assert last_response.ok?
    assert last_response.body.include?(title1)
    assert last_response.body.include?('super')
    assert last_response.body.include?(content1)
    # Edit post.
    post '/author/articles/edit', {:title => title2, :content => content2}
    assert last_response.redirect?
    # Test listing page.
    get '/blog'
    assert last_response.ok?
    assert last_response.body.include?(title2)
    assert last_response.body.include?('super')
    # Test post page.
    get '/blog/1'
    assert last_response.ok?
    assert last_response.body.include?(title2)
    assert last_response.body.include?('super')
    assert last_response.body.include?(content2)
    # Delete post.
    get '/author/articles/delete/1'
    assert last_response.redirect?
    # Test listing page.
    get '/blog'
    assert last_response.ok?
    assert !last_response.body.include?(title2)
    assert !last_response.body.include?('super')
    assert !last_response.body.include?(content2)
    log_out
end

def wrapper_news_api(title1, content1, title2, content2)
    # Log in to perform secured actions.
    log_in('testuser', 'testpassword')
    # Initial test.
    get '/'
    assert last_response.ok?
    # Create post.
    post '/author/news/create', {:title => title1, :content => content1}
    assert last_response.redirect?
    # Test listing page.
    get '/'
    assert last_response.ok?
    assert last_response.body.include?(title1)
    assert last_response.body.include?('super')
    # Test post page.
    get '/news/1'
    assert last_response.ok?
    assert last_response.body.include?(title1)
    assert last_response.body.include?('super')
    assert last_response.body.include?(content1)
    # Edit post.
    post '/author/news/edit', {:title => title2, :content => content2}
    assert last_response.redirect?
    # Test listing page.
    get '/'
    assert last_response.ok?
    assert last_response.body.include?(title2)
    assert last_response.body.include?('super')
    # Test post page.
    get '/news/1'
    assert last_response.ok?
    assert last_response.body.include?(title2)
    assert last_response.body.include?('super')
    assert last_response.body.include?(content2)
    # Delete post.
    get '/author/news/delete/1'
    assert last_response.redirect?
    # Test listing page.
    get '/'
    assert last_response.ok?
    assert !last_response.body.include?(title2)
    assert !last_response.body.include?('super')
    assert !last_response.body.include?(content2)
    log_out
end

def log_in(username, password)
    post '/sso/author/login', {:inputUser => username, :inputPassword => password}
end

def log_out
    get '/sso/author/logout'
end