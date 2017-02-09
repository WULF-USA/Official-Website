require 'dalli'
require 'resque'
require_relative '../jobs/reload_cache'

module Lib
    module Cache
        DC = Dalli::Client.new(ENV['MEMCACHIER_SERVERS'], { :namespace => "wulfusa", :compress => true })
        def Cache.read(key)
            return DC.get(key)
        end
        def Cache.set(key, value)
            DC.set(key, value)
        end
        def Cache.invalidate_all!
            Resque.enqueue(ReloadCache)
        end
    end
end