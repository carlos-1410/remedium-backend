module Api
  module V1
    class PostsController < BaseController
      def index
        render json: posts,
          root: "posts",
          status: :ok,
          meta: pagination_attributes(posts),
          meta_key: "pagination",
          each_serializer: Api::V1::PostSerializer
      end

      def show
        render json: post,
          root: "post",
          serializer: Api::V1::PostSerializer
      end

      def create
        action = Posts::Create.new(Post.new(post_params)).call

        if action.success?
          render json: action.value,
            status: :created,
            root: "post",
            serializer: Api::V1::PostSerializer
        else
          render_exception(action.value)
        end
      end

      def update
        action = Posts::Update.new(post, params: post_params).call

        if action.success?
          render json: action.value,
            root: "post",
            serializer: Api::V1::PostSerializer
        else
          render_exception(action.value)
        end
      end

      def destroy
        action = Posts::Destroy.new(post).call

        if action.success?
          render status: :no_content
        else
          render_exception(action.value)
        end
      end

      private

      def post
        @post ||= Post.find(params[:id])
      end

      def posts
        @posts ||= Posts::Filterer.new(**filterer_params).call
      end

      def post_params
        params
          .require(:post)
          .permit(:id, :title, :body, :archived, :hidden, :included_in_sitemap,
            :visible_from, :visible_to, :image, tags: [], meta_tags: [])
      end

      def filterer_params
        params.permit(
          :ids, { ids: [] }, { tags: [] }, { meta_tags: [] },
          :title, :body, :archived, :hidden, :included_in_sitemap,
          :created_at_gte, :created_at_lte, :visible_from_gte, :visible_from_lte,
          :visible_to_gte, :visible_to_lte, :order_column, :order_direction, :page, :per_page
        )
      end
    end
  end
end
