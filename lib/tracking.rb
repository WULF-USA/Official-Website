require_relative '../jobs/track'

module Lib
    module Tracking
        ##
        # Launches a background job to add tracking data to specified URL marker.
        def tick_url(url)
            Resque.enqueue(Track, url)
        end
    end
end