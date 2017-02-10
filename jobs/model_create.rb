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
        class Create
            include Resque::Plugins::Status
            
            #@queue = :models
            
            def perform
                # Find object in database.
                begin
                    @type = options['model_type'].split('::').reduce(Module, :const_get)
                    at(1, 3)
                    @type.create!(options['args'])
                    at(2, 3)
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
                rescue ActiveRecord::RecordInvalid
                    failed(msg: 'Invalid parameters')
                    return
                rescue
                    failed(msg: 'Invalid parameter names')
                    return
                end
                # Invalidate the cache.
                Resque.enqueue(Jobs::Cache::ReloadCache)
                # Update progess.
                at(3, 3)
                # Terminate the job.
                completed
            end
        end
    end
end