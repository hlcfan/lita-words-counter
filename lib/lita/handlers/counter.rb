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
        username = response.matches[0][0]
        keys = redis.keys "#{user_key(username)}*"
        lines = keys.map do |key|
          "#{unuser_key(key)} said #{redis.get(key)} lines"
        end.join("\n")

        response.reply lines
      end

      def recount response
        keys = redis.keys "user-*"
        redis.del keys if keys.any?
        response.reply '*recount done!*'
      end

      private

      def user_key username
        "user-#{username}".downcase
      end

      def unuser_key username
        username.gsub('user-', '')
      end

    end

    Lita.register_handler(Counter)

  end
end