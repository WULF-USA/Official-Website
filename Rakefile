#require_relative './wulf_app.rb'
require 'sinatra/activerecord/rake'
require 'resque/tasks'
require_relative './jobs/track'
require_relative './jobs/reload_cache'
require_relative './jobs/reload_cache_home'
require_relative './jobs/model_delete'
require_relative './jobs/model_edit'
require_relative './jobs/model_create'

task :jobdump do
    puts Resque::Plugins::Status::Hash.statuses
end