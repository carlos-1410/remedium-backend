require "test_helper"

module Settings
  class UpdateTest < ActiveSupport::TestCase
    test "inherits from base class" do
      assert Update < Operations::Update
    end

    test "update succeeds" do
      params = {
        contact_email: "email@test.com",
        contact_phone: "123456789",
        meta_tags: ["new_tag"],
        facebook_url: "http://fburl.com/",
      }
      response = Update.new(setting, params:).call

      assert response.success?
      assert_equal response.value.contact_email, params[:contact_email]
      assert_equal response.value.contact_phone, params[:contact_phone]
      assert_equal response.value.meta_tags, params[:meta_tags]
      assert_equal response.value.facebook_url, params[:facebook_url]

      setting.destroy
    end

    test "update fails without required params" do
      params = {
        meta_tags: nil,
        meta_title: nil,
        contact_email: nil,
        meta_description: nil,
      }
      response = Update.new(setting, params:).call
      expected_error = "Contact email can't be blank, " \
                       "Meta tags can't be blank, " \
                       "Meta title can't be blank, " \
                       "Meta description can't be blank, and " \
                       "Contact email is invalid"

      assert response.failure?
      assert_equal response.value, expected_error
    end

    test "attach favicon and logo fails when it's a text file" do
      params = { favicon: text_file, logo: text_file }
      response = Update.new(setting, params:).call
      expected_error = "Favicon needs to be an image and " \
                       "Logo needs to be an image"

      assert response.failure?
      assert_equal response.value, expected_error
    end

    test "attach favicon and logo succeeds when it's an image" do
      params = { favicon: image_file, logo: image_file }
      response = Update.new(setting, params:).call

      assert response.success?
      assert response.value.favicon.attached?
      assert response.value.logo.attached?
    end

    private

    def setting
      @setting ||= create(:setting)
    end

    def text_file
      filename = "empty_file.txt"
      file = File.open(Rails.root.join("test/factories/attachments/#{filename}").to_s)
      ActiveStorage::Blob.create_and_upload!(io: file, filename: filename)
    end

    def image_file
      filename = "avatar.jpeg"
      file = File.open(Rails.root.join("test/factories/attachments/#{filename}").to_s)
      ActiveStorage::Blob.create_and_upload!(io: file, filename: filename)
    end
  end
end
