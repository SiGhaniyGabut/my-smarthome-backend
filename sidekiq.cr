require "sidekiq/cli"
require "./src/jobs/**"

cli = Sidekiq::CLI.new
server = cli.configure { |config| config.redis = Sidekiq::RedisConfig.new(db: 10) }

cli.run(server)