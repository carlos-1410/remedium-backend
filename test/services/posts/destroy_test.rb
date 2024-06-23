require "test_helper"

module Posts
  class DestroyTest < ActiveSupport::TestCase
    test "inherits from base class" do
      assert Destroy < Operations::Destroy
    end

    test "destroy succeeds" do
      post = create(:post)
      response = Destroy.new(post).call

      assert response.success?
    end
  end
end
