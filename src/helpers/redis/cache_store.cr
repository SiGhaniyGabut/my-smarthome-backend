module Helpers
  module Redis
    class CacheStore
      getter connection : Connection

      def initialize(@connection = Connection.new)
      end

      def self.connect
        @@connect ||= new
      end

      def self.connect(connection : Connection)
        @@connect ||= new connection
      end

      def read(key : String)
        connection.redis do |redis|
          redis.get cache_key key
        end
      end

      def write(key : String, value : String, expires_in : Time::Span | Number | Nil = nil)
        connection.redis do |redis|
          redis.set cache_key(key), value, ex: to_seconds expires_in
        end
      end

      def delete(key : String)
        connection.redis do |redis|
          action_return redis.del cache_key key
        end
      end

      def exists?(key : String)
        connection.redis do |redis|
          action_return redis.exists cache_key key
        end
      end

      def fetch(key : String, expires_in : Time::Span | Number | Nil = nil)
        value = read key
        return value unless value.nil?

        value = yield
        write key, value, expires_in
        value
      end

      private def cache_key(key)
        "cache_store:#{key}"
      end

      private def to_seconds(time : Time::Span | Number | Nil)
        return time if time.is_a? Number || time.is_a? Nil

        time.total_seconds.to_i64
      end

      private def action_return(action)
        return true if action == 1

        false
      end
    end
  end
end
