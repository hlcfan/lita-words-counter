require "lita"

module Lita
  module Handlers
    class Counter < Handler
      route /.*/,                         :counter
      route /\Acount\s?(.*)?\z/i,         :count,         command: true
      route /\Arecount\s?(.*)?\z/i,       :recount,       command: true

      def counter response
        redis.incr(user_key(response.user.name))
      end

      def count response
        response.reply(redis.get(user_key(response.matches[0][0])) || '0')
      end

      def recount response
        keys = redis.keys "user-*"
        redis.del keys if keys.any?
        response.reply '**recount done!**'
      end

      private

      def user_key user_name
        "user-#{user_name}"
      end
    end

    Lita.register_handler(Counter)

  end
end