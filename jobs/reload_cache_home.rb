require 'resque'
require 'sinatra/activerecord'
require 'redis'
require_relative '../lib/cache.rb'
require_relative '../lib/home_data'

module Jobs
    module Cache
        class ReloadCacheHome
            @queue = :cache
            
            def self.perform()
                # Create HomeData object.
                hd = HomeData.new
                # Load values from DB.
                hd.load_all
                # Store object in cache.
                Lib::Cache.set('cache_home', hd)
            end
        end
    end
end