require 'dalli'
require 'resque'
require_relative '../jobs/reload_cache_home'
require_relative './cache'
require_relative './home_data'

module Lib
    module Cache
        module Home
            
            ##
            # Gets the metadata from cache, on failure resorts to DB.
            def Home.get_metadata
                # Get the HomeData object from cache.
                data = Lib::Cache.read('cache_home')
                # Check if object is valid.
                if(data == nil || !data.valid?)
                    # Invalid, recreate from DB values.
                    data = HomeData.new
                    data.load_all
                    # Queue up a job to recreate cache values.
                    Resque.enqueue(Jobs::Cache::ReloadCacheHome)
                    # Return cache-miss object loaded from DB.
                    return data
                else
                    # Object is valid, return it.
                    return data
                end
            end
            
            ##
            # Invalidates only the home cache.
            def Home.invalidate!
                # Queue up a background job to refresh the cache values.
                Resque.enqueue(Jobs::Cache::ReloadCacheHome)
            end
        end
    end
end