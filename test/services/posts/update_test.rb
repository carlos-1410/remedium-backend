require "test_helper"

module Posts
  class UpdateTest < ActiveSupport::TestCase
    test "inherits from base class" do
      assert Update < Operations::Update
    end

    test "update succeeds" do
      post = create(:post)
      title = "My post"
      response = Update.new(post, params: { title: }).call

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
      response = Update.new(post, params:).call

      assert response.failure?
      assert_equal response.value, expected_error
    end

    test "remove image" do
      post = create(:post)
      params = { image: nil }
      response = Update.new(post, params:).call

      assert response.success?
      assert_not response.value.image.attached?
    end
  end
end
