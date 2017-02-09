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
    def get_blog_data
        return @blog
    end
    def valid?
        return @videos != nil && @news != nil && @blog != nil
    end
    def load_all
        self.load_videos
        self.load_news
        self.load_blog
    end
    def load_videos
        
    end
    def load_news
        
    end
    def load_blog
        
    end
end