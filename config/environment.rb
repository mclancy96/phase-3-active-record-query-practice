require "bundler/setup"
Bundler.require

require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/movies.sqlite3"
)

ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV["VERBOSE"]

require_relative "../app/models/movie"

# RSpec configuration
require 'rspec'
RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = ON")
  end

  config.around(:each) do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
