require 'sinatra/activerecord'
require_relative '../models/feeds'
require_relative '../models/articles'
require_relative '../models/videos'

class HomeData
    
    ##
    # Empty initializer.
    def initialize
        
    end
    
    ##
    # Sets the value of video cache.
    def set_video_cache(data)
        @videos = data
    end
    
    ##
    # Sets the value of news cache.
    def set_news_cache(data)
        @news = data
    end
    
    ##
    # Sets the value of blog cache.
    def set_blog_cache(data)
        @blog = data
    end
    
    ##
    # Gets the value of video cache.
    def get_video_cache
        return @videos
    end
    
    ##
    # Gets the value of news cache.
    def get_news_cache
        return @news
    end
    
    ##
    # Gets the value of blog cache.
    def get_blog_cache
        return @blog
    end
    
    ##
    # Returns if object contains valid cache values for all fields.
    def valid?
        return @videos != nil && @news != nil && @blog != nil
    end
    
    ##
    # Wrapper call to load all cache values from DB.
    def load_all()
        self.load_videos
        self.load_news
        self.load_blog
    end
    
    ##
    # Load video cache from DB.
    def load_videos
        feed = Array.new
        videos = Video.all.order(created_at: :desc).limit(3)
        videos.each do |video|
            feed.push(video.generate_metadata)
        end
        @videos = feed
    end
    
    ##
    # Load news cache from DB.
    def load_news
        feed = Array.new
        news = Feed.all.order(created_at: :desc).limit(4)
        news.each do |item|
            feed.push(item.generate_metadata)
        end
        @news = feed
    end
    
    ##
    # Load blog cache from DB.
    def load_blog
        feed = Array.new
        articles = Article.all.order(created_at: :desc).limit(5)
        articles.each do |item|
            feed.push(item.generate_metadata)
        end
        @blog = feed
    end
end