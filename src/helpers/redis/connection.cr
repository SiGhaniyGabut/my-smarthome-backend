require "redis"

module Helpers
  module Redis
    class Connection
      getter hostname     : String
      getter port         : Int32
      getter db           : Int32
      getter pool_size    : Int32
      getter pool_timeout : Float64
      getter password     : String?
      getter redis_pool   : ConnectionPool(::Redis)

      def initialize(@hostname = "localhost", @port = 6379, @db = 10, @pool_size = 26, @pool_timeout = 5.0, @password = nil)
        @redis_pool = ::Redis::PooledClient.new(
          host: @hostname,
          port: @port,
          database: @db,
          pool_size: @pool_size,
          pool_timeout: @pool_timeout,
          password: @password
        ).pool
      end

      def redis
        connection = @redis_pool.checkout
        yield connection
      ensure
        @redis_pool.checkin connection if connection
      end
    end
  end
end
