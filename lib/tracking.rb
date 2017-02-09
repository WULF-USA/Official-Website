require_relative '../jobs/track'

module Lib
    module Tracking
        def tick_url(url)
            Resque.enqueue(Track, url)
        end
    end
end