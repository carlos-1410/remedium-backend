module Posts
  module Update
    class Action
      def initialize(post, params:)
        @params = params
        @post = post
      end

      def call
        update_post
      end

      private

      attr_reader :params, :post

      def update_post
        response = post.save_with_response(**params)

        return Response.success(post) if response.success?

        Response.failure(post.errors.full_messages.to_sentence)
      end
    end
  end
end
