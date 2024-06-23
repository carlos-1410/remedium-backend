require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "title and body are mandatory" do
    post = build(:post, title: nil, body: nil)

    assert post.invalid?
    assert post.errors.added?(:title, :blank)
    assert post.errors.added?(:body, :blank)
  end
end
