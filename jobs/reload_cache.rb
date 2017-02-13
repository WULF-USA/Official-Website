require 'resque'
require 'sinatra/activerecord'
require 'redis'
require 'time'
require_relative '../lib/cache'
require_relative './reload_cache_home'

module Jobs
    module Cache
        class ReloadCache
            
            @queue = :cache
            
            def self.perform()
                # Enqueue all cache reload subjobs.
                Resque.enqueue(ReloadCacheHome)
                # Update the timestamp on the cache.
                Lib::Cache.set("cache-all-updated", Time.now.getutc)
            end
        end
    end
end