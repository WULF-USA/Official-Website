require 'dalli'
require 'resque'
require_relative '../jobs/reload_cache'

module Lib
    module Cache
        
        # Create a static Dalli object to handle Memcache connections.
        DC = Dalli::Client.new(ENV['MEMCACHIER_SERVERS'], {
            :expires_in => 30.minutes,
            :compress => true,
            :namespace => ENV['MEMCACHIER_NAMESPACE'],
            :username => ENV['MEMCACHIER_USERNAME'],
            :password => ENV['MEMCACHIER_PASSWORD']})
        
        ##
        # Read a key from the cache.
        def Cache.read(key)
            return DC.get(key)
        end
        
        ##
        # Set a value in the cache.
        def Cache.set(key, value)
            DC.set(key, value)
        end
        
        ##
        # Invalidate the cache and queue a job to refresh it.
        def Cache.invalidate_all!
            Resque.enqueue(ReloadCache)
        end
    end
end
