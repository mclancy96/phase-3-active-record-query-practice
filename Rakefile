require_relative 'config/environment'

# Rake tasks
desc 'Start the console'
task :console do
  Pry.start
end

desc 'Run the test suite'
task :spec do
  exec 'rspec'
end

namespace :db do
  desc 'Run migrations'
  task :migrate do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::MigrationContext.new('db/migrate').migrate
  end

  desc 'Seed the database'
  task :seed do
    load 'db/seeds.rb'
  end

  desc 'Reset database (drop, create, migrate, seed)'
  task :reset do
    File.delete('db/movies.sqlite3') if File.exist?('db/movies.sqlite3')
    ActiveRecord::Migration.verbose = false
    ActiveRecord::MigrationContext.new('db/migrate').migrate
    load 'db/seeds.rb'
    puts "Database reset complete!"
  end
end# Default task
task default: :spec
