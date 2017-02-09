require 'resque'
require 'sinatra/activerecord'
require 'redis'
require_relative '../lib/cache.rb'

class ReloadCacheHome
    @queue = :cache
    
    def self.perform()
        
    end
end