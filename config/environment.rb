require "bundler/setup"
require "hanami/setup"
require "hanami/model"
require_relative "../lib/hanami_diary"
require_relative "../apps/web/application"

Hanami.configure do
  mount Web::Application, at: "/"

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/hanami_diary_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/hanami_diary_development'
    #    adapter :sql, 'mysql://localhost/hanami_diary_development'
    #
    adapter :sql, ENV.fetch("DATABASE_URL")

    ##
    # Migrations
    #
    migrations "db/migrations"
    schema "db/schema.sql"
  end

  environment :development do
    # See: https://guides.hanamirb.org/projects/logging
    logger level: :debug
  end

  environment :production do
    logger level: :info, formatter: :json, filter: []
  end
end
