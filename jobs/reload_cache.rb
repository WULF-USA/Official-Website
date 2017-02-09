require 'resque'
require 'sinatra/activerecord'
require 'redis'
require 'time'
require_relative '../lib/cache'

module Jobs
    module Cache
        class ReloadCache
            @queue = :cache
            
            def self.perform()
                Resque.enqueue(ReloadCacheHome)
                Lib::Cache.set("cache-all-updated", Time.now.getutc)
            end
        end
    end
end