require 'dalli'

module Lib
    module Cache
        DC = Dalli::Client.new('localhost:11211', { :namespace => "wulfusa", :compress => true })
        def read(key)
            return DC.get(key)
        end
        def set(key, value)
            DC.set(key, value)
        end
        def invalidate_all!
            # TODO: Reload entire cache
        end
    end
end