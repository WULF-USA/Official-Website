require 'resque'
require 'sinatra/activerecord'
require 'redis'
#require_relative '../config/environments'
require_relative '../models/trackers'

class Track
    @queue = :tracking
    
    def self.perform(url)
        Resque.logger.fatal "RRRREEEEEEEE IM TRIGGERED!!!!!"
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