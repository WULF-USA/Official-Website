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
        class Delete
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
                    @obj = @type.find(options['model_id'])
                rescue ActiveRecord::RecordNotFound
                    # Invalid ID.
                    failed(msg: t.notifications.recmiss.to_s)
                    return
                rescue NameError
                    # Invalid model type.
                    failed(msg: t.notifications.deleteerror(t.types.public_send(options['model_type'].downcase)).to_s)
                    return
                rescue NoMethodError
                    # Invalid model type.
                    failed(msg: t.notifications.deleteerror(t.types.public_send(options['model_type'].downcase)).to_s)
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
                    completed(msg: t.notifications.deletesucc(t.types.public_send(options['model_type'].downcase)).to_s)
                else
                    # Invalid permissions.
                    failed(msg: t.notifications.permissions.to_s)
                    return
                end
            end
        end
    end
end