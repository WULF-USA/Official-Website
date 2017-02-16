require 'resque'
require 'resque-status'
require 'sinatra/activerecord'
require 'redis'
require 'r18n-desktop'
require_relative './reload_cache.rb'
require_relative '../models/videos'
require_relative '../models/articles'
require_relative '../models/feeds'
require_relative '../models/resources'

module Jobs
    module Models
        class Create
            include Resque::Plugins::Status
            include R18n::Helpers
            
            @queue = :models
            
            def perform
                # Tell the i18n library where to look for translation files and what locale to use.
                R18n.from_env('./i18n/', options['lang'])
                
                # Since dynamic dispatch is being used, verify that the contents of the options=>model_type hash are clean.
                if ['video', 'resource', 'article', 'feed'].include?(options['model_type'].downcase)
                    # Values are clean.
                else
                    failed(t.notifications.xsrf.to_s)
                    return
                end
                
                # Find object in database.
                begin
                    # Convert string parameter 'type' into specified ActiveRecord Model class.
                    @type = options['model_type'].split('::').reduce(Module, :const_get)
                    at(1, 3)
                    @type.create!(options['args'])
                    at(2, 3)
                rescue ActiveRecord::RecordNotFound
                    # Invalid ID.
                    failed(msg: t.notifications.recmiss.to_s)
                    return
                rescue NameError
                    # Invalid model type.
                    failed(msg: t.notifications.saveerror(t.types.public_send(options['model_type'].downcase)).to_s)
                    return
                rescue NoMethodError
                    # Invalid model type.
                    failed(msg: t.notifications.saveerror(t.types.public_send(options['model_type'].downcase)).to_s)
                    return
                rescue ActiveRecord::RecordInvalid
                    # Record validation failed.
                    failed(msg: t.notifications.saveerror(t.types.public_send(options['model_type'].downcase)).to_s)
                    return
                rescue
                    # Invalid parameters.
                    failed(msg: t.notifications.saveerror(t.types.public_send(options['model_type'].downcase)).to_s)
                    return
                end
                # Invalidate the cache.
                Resque.enqueue(Jobs::Cache::ReloadCache)
                # Update progess.
                at(3, 3)
                # Terminate the job.
                completed(msg: t.notifications.savesucc(t.types.public_send(options['model_type'].downcase)).to_s)
            end
        end
    end
end