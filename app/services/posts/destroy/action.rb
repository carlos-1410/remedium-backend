module Posts
  module Destroy
    class Action
      def initialize(post)
        @post = post
      end

      def call
        destroy_post
      end

      private

      attr_reader :post

      def destroy_post
        response = post.destroy_with_response

        return Response.success(true) if response.success?

        Response.failure(post.errors.full_messages.to_sentence)
      end
    end
  end
end
