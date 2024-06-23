require "test_helper"

module Posts
  module Update
    class ActionTest < ActiveSupport::TestCase
      test "update succeeds" do
        post = create(:post)
        title = "My post"
        response = Action.new(post, params: { title: }).call

        assert response.success?
        assert_equal response.value.title, title
      end

      test "update fails without required params" do
        post = create(:post)
        params = {
          title: nil,
          body: nil,
        }
        expected_error = "Title can't be blank and Body can't be blank"
        response = Action.new(post, params:).call

        assert response.failure?
        assert_equal response.value, expected_error
      end

      test "remove image" do
        post = create(:post)
        params = { image: nil }
        response = Action.new(post, params:).call

        assert response.success?
        assert_not response.value.image.attached?
      end
    end
  end
end
