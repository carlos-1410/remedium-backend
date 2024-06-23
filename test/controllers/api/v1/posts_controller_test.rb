require "test_helper"

module Api
  module V1
    class PostsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = create(:user, :admin)
        sign_in @user
      end

      test "index found posts by id" do
        post = create(:post)

        get api_v1_posts_url(params: { ids: post.id })

        assert_json_schema_match "api/v1/posts/index", response.json
        assert_response :ok

        assert_equal 1, response.json[:posts].count
        assert_detailed post, response.json[:posts].first
      end

      test "index found posts by title" do
        post = create(:post)

        get api_v1_posts_url(params: { title: post.title[0..5] })

        assert_json_schema_match "api/v1/posts/index", response.json
        assert_response :ok

        assert_equal 1, response.json[:posts].count
        assert_detailed post, response.json[:posts].first
      end

      test "index found posts by tags" do
        create_list(:post, 3, tags: ["test"])
        create_list(:post, 3, tags: ["xxx"])
        create_list(:post, 3)

        get api_v1_posts_url(params: { tags: %w(test xxx) })

        assert_json_schema_match "api/v1/posts/index", response.json
        assert_response :ok

        assert_equal 6, response.json[:posts].count
      end

      test "index found posts by included_in_sitemap" do
        create_list(:post, 3)
        post = create(:post, included_in_sitemap: false)

        get api_v1_posts_url(params: { included_in_sitemap: false })

        assert_json_schema_match "api/v1/posts/index", response.json
        assert_response :ok

        assert_equal 1, response.json[:posts].count
        assert_detailed post, response.json[:posts].first
      end

      test "index is paginated and sorted by default by updated_at :desc" do
        create(:post)
        last = create(:post)

        get api_v1_posts_url

        assert_json_schema_match "api/v1/posts/index", response.json
        assert_response :ok

        assert_equal 2, response.json[:posts].count
        assert_equal 25, response.json[:pagination][:per_page]
        assert_equal last.id, response.json[:posts].first[:id]
      end

      test "index is paginated and sorted by visible_to :desc" do
        first = create(:post, visible_to: "2024-06-01")
        create(:post, visible_to: "2024-06-02")

        get api_v1_posts_url(params: { order_column: "visible_to", order_direction: "asc" })

        assert_json_schema_match "api/v1/posts/index", response.json
        assert_response :ok

        assert_equal 2, response.json[:posts].count
        assert_equal 25, response.json[:pagination][:per_page]
        assert_equal first.id, response.json[:posts].first[:id]
      end

      test "create succeds" do
        new_post = build(:post)
        params = new_post.attributes

        post api_v1_posts_url, params: params, as: :json

        assert_json_schema_match "api/v1/posts/post", response.json
        assert_response :created
      end

      test "create fails" do
        new_post = build(:post, title: nil)
        params = new_post.attributes
        expected_response = { error: "Title can't be blank" }

        post api_v1_posts_url, params: params, as: :json

        assert_equal response.json, expected_response
      end

      test "update succeds" do
        new_post = create(:post)
        title = "new title"
        params = new_post.attributes.merge(title:)

        put api_v1_post_url(id: new_post.id), params:, as: :json

        assert_json_schema_match "api/v1/posts/post", response.json
        assert_response :ok
        assert_equal new_post.reload.title, title
      end

      test "update fails" do
        new_post = create(:post)
        params = new_post.attributes.merge(title: nil)
        expected_response = { error: "Title can't be blank" }

        put api_v1_post_url(id: new_post.id), params:, as: :json

        assert_equal response.json, expected_response
      end

      test "destroy" do
        new_post = create(:post)

        assert_difference -> { Post.count }, -1 do
          delete api_v1_post_url(id: new_post.id)

          assert_response :no_content
        end
      end

      private

      def assert_detailed(expected, found) # rubocop:disable Metrics/AbcSize
        assert_equal expected.title, found[:title]
        assert_equal expected.body, found[:body]
        assert_equal expected.tags, found[:tags]
        assert_equal expected.meta_tags, found[:meta_tags]
        assert_equal expected.slug, found[:slug]
        assert_equal expected.archived, found[:archived]
        assert_equal expected.included_in_sitemap, found[:included_in_sitemap]
        assert_equal expected.hidden, found[:hidden]
        assert_datetime expected.visible_from, found[:visible_from]
        assert_datetime expected.visible_to, found[:visible_to]
        assert_datetime expected.created_at, found[:created_at]
        assert_datetime expected.updated_at, found[:updated_at]
      end
    end
  end
end
