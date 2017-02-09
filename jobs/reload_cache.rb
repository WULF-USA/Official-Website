require 'resque'
require 'sinatra/activerecord'
require 'redis'

class ReloadCache
    @queue = :cache
    
    def self.perform()
        Resque.enqueue(ReloadCacheHome)
    end
end