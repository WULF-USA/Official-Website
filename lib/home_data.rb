require 'sinatra/activerecord'
require_relative '../models/feeds'
require_relative '../models/articles'
require_relative '../models/videos'

class HomeData
    def initialize
        
    end
    def set_video_cache(data)
        @videos = data
    end
    def set_news_cache(data)
        @news = data
    end
    def set_blog_cache(data)
        @blog = data
    end
    def get_video_cache
        return @videos
    end
    def get_news_cache
        return @news
    end
    def get_blog_cache
        return @blog
    end
    def valid?
        return @videos != nil && @news != nil && @blog != nil
    end
    def load_all()
        self.load_videos
        self.load_news
        self.load_blog
    end
    def load_videos
        feed = Array.new
        videos = Video.all.order(created_at: :desc).limit(3)
        videos.each do |video|
            feed.push(video.generate_metadata)
        end
        @videos = feed
    end
    def load_news
        feed = Array.new
        news = Feed.all.order(created_at: :desc).limit(4)
        news.each do |item|
            feed.push(item.generate_metadata)
        end
        @news = feed
    end
    def load_blog
        feed = Array.new
        articles = Article.all.order(created_at: :desc).limit(5)
        articles.each do |item|
            feed.push(item.generate_metadata)
        end
        @blog = feed
    end
end