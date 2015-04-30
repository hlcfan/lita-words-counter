require "lita"

module Lita
  module Handlers
    class Counter < Handler
      REDIS_SET_KEY = "counts"

      route /.*/,                         :counter
      route /\Acount\s+(.*+)\z/i,         :count,         command: true
      route /\Arecount\s?(.*)?\z/i,       :recount,       command: true
      route /^count\s+top\s+(\d+)/,       :list_top,      command: true

      def counter response
        return if response.user.name.delete(' ') == ''
        redis.zincrby REDIS_SET_KEY, 1, user_key(response.user.name)
      end

      def count response
        username = response.matches[0][0]
        scores = find_scores_by_username username
        response.reply generate_lines *scores
      end

      def recount response
        redis.del REDIS_SET_KEY
        response.reply '*recount done!*'
      end

      def list_top response
        top_n = response.matches[0][0].to_i - 1
        scores = redis.zrevrange REDIS_SET_KEY, 0, top_n, with_scores: true
        response.reply generate_lines(scores)
      end

      private

      def user_key username
        "user-#{username}".downcase
      end

      def unuser_key username
        username.gsub('user-', '')
      end

      def find_scores_by_username name
        scores = redis.zscan REDIS_SET_KEY, 0, { match: "#{user_key(name)}*" }
        scores[1..-1]
      end

      def generate_lines scores
        scores.map do |score|
          "#{unuser_key(score[0])} said #{score[1].to_i} lines"
        end.join("\n")
      end

    end

    Lita.register_handler(Counter)

  end
end