module Posts
  module Create
    class Action
      def initialize(params:)
        @params = params
      end

      def call
        return Response.failure(post.errors.full_messages.to_sentence) unless post.valid?

        create_post
      end

      private

      attr_reader :params

      def post
        @post ||= Post.new(**params)
      end

      def create_post
        post.save_with_response
      end
    end
  end
end
