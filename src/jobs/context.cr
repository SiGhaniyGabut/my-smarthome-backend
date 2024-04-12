require "sidekiq"
require "../../config/application"

Sidekiq::Client.default_context = Sidekiq::Client::Context.new redis_cfg: Sidekiq::RedisConfig.new(db: 10)
