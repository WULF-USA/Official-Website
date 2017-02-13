require 'sinatra'
require 'resque'
require 'resque-status'
require 'json'

module Routing
    module API
        module Jobs
            def self.registered(app)
                ##
                # Job status endpoint. (NOAUTH)
                app.get '/api/v1/job/:id' do
                    # Return the job hash as a JSON object.
                    return Resque::Plugins::Status::Hash.get(params['id']).to_json
                end
            end
        end
    end
end