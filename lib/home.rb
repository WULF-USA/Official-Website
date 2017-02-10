require 'dalli'
require 'resque'
require_relative '../jobs/reload_cache_home'
require_relative './cache'
require_relative './home_data'

module Lib
    module Cache
        module Home
            def Home.get_metadata
                data = Lib::Cache.read('cache_home')
                if(data == nil || !data.valid?)
                    data = HomeData.new
                    data.load_all
                    Resque.enqueue(Jobs::Cache::ReloadCacheHome)
                    return data
                else
                    return data
                end
            end
            def Home.invalidate!
                Resque.enqueue(Jobs::Cache::ReloadCacheHome)
            end
        end
    end
end