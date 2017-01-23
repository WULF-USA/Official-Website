require_relative '../models/trackers'

module Lib
    module Tracking
        def tick_url(url)
            # Try to look for the tracker by URL.
            tracker_obj = Tracker.find_by(url: url)
            if(tracker_obj == nil)
                # URL doesn't exist in DB, create it.
                tracker_obj = Tracker.create(url: url, visits: 0)
            end
            # Increment visit value.
            tracker_obj.visits = tracker_obj.visits + 1
            # Don't use ! as the tracker should be passive.
            tracker_obj.save
        end
    end
end