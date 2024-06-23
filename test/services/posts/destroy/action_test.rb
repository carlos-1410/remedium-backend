require "test_helper"

module Posts
  module Destroy
    class ActionTest < ActiveSupport::TestCase
      test "destroy succeeds" do
        post = create(:post)
        response = Action.new(post).call

        assert response.success?
      end
    end
  end
end
