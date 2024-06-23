require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "title and body are mandatory" do
    post = build(:post, title: nil, body: nil)

    assert post.invalid?
    assert post.errors.added?(:title, :blank)
    assert post.errors.added?(:body, :blank)
  end

  test "validate image_format" do
    filename = "empty_file.txt"
    file = File.open(Rails.root.join("test/factories/attachments/#{filename}").to_s)
    image = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename)

    post = build(:post, image:)
    assert post.invalid?
    assert post.errors.added?(:image, "needs to be an image")
  end
end
