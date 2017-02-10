require 'resque'
require 'resque-status'
require 'sinatra/activerecord'
require 'redis'
require_relative './reload_cache.rb'
require_relative '../models/videos'
require_relative '../models/articles'
require_relative '../models/feeds'
require_relative '../models/resources'

module Jobs
    module Models
        class Edit
            include Resque::Plugins::Status
            
            #@queue = :models
            
            def perform
                # Find object in database.
                begin
                    @type = options['model_type'].split('::').reduce(Module, :const_get)
                    @obj = @type.find(options['model_id'])
                rescue ActiveRecord::RecordNotFound
                    # Invalid ID.
                    failed(msg: 'Model not found')
                    return
                rescue NameError
                    # Invalid model type.
                    failed(msg: 'Invalid model ref')
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
                    # Update the object.
                    begin
                        @obj.update!(options['args'])
                    rescue ActiveRecord::RecordInvalid
                        failed(msg: 'Invalid parameters')
                        return
                    rescue
                        failed(msg: 'Invalid parameter names')
                        return
                    end
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