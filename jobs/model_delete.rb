require 'resque'
require 'resque-status'
require 'sinatra/activerecord'
require 'redis'
require_relative './reload_cache.rb'
require_relative '../models/feeds'
require_relative '../models/articles'
require_relative '../models/resources'
require_relative '../models/videos'

module Jobs
    module Models
        module Videos
            class Delete
                include Resque::Plugins::Status
                
                #@queue = :models
                
                def perform
                    # Find video in database.
                    begin
                        @obj = Video.find(options['model_id'])
                    rescue ActiveRecord::RecordNotFound
                        # Invalid ID.
                        failed(msg: 'Model not found')
                        return
                    rescue NoMethodError
                        # Invalid model type.
                        failed(msg: 'Internal error')
                        return
                    end
                    # Update progress.
                    at(1, 4)
                    # Verify permissions.
                    if options['user_id'] == @obj.author || options['user_id'] == 'super' || options['is_super']
                        # Update progress.
                        at(2,4)
                        # Destroy the object.
                        @obj.destroy
                        # Update progress.
                        at(3,4)
                        # Invalidate the cache.
                        Resque.enqueue(Jobs::Cache::ReloadCache)
                        # Update progess.
                        at(4,4)
                        # Terminate the job.
                        completed
                    else
                        # Invalid permissions.
                        failed(msg: 'Incorrect permissions')
                        return
                    end
                end
            end
        end
    end
end