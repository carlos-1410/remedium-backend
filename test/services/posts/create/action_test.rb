require "test_helper"

module Posts
  module Create
    class ActionTest < ActiveSupport::TestCase
      test "create succeeds with valid params and an image" do
        params = {
          title: "My post",
          body: "<content goes here>",
          image: image,
        }
        response = Action.new(params:).call

        assert response.success?
        assert response.value.image.attached?
        assert_equal response.value.image.filename, filename
      end

      test "create fails without required params" do
        params = {
          title: nil,
          body: nil,
        }
        expected_error = "Title can't be blank and Body can't be blank"
        response = Action.new(params:).call

        assert response.failure?
        assert_equal response.value, expected_error
      end

      private

      def image
        file = File.open(Rails.root.join("test/factories/attachments/#{filename}").to_s)
        ActiveStorage::Blob.create_and_upload!(io: file, filename: filename)
      end

      def filename
        "avatar.jpeg"
      end
    end
  end
end
