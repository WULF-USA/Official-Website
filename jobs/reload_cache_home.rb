require 'resque'
require 'sinatra/activerecord'
require 'redis'
require_relative '../lib/cache.rb'
require_relative '../lib/home_data'

class ReloadCacheHome
    @queue = :cache
    
    def self.perform()
        hd = HomeData.new
        hd.load_all
        Lib::Cache.set('cache_home', hd)
    end
end