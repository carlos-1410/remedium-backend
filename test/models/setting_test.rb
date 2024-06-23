require "test_helper"

class SettingTest < ActiveSupport::TestCase
  test "fails if already exists" do
    assert_difference -> { Setting.count }, +1 do
      create(:setting)
      second_one = build(:setting)
      second_one.save

      expected_error = "Only 1 instance of Setting is allowed"

      assert_equal expected_error, second_one.errors.full_messages.to_sentence
    end
  end

  test "email format" do
    setting = build(:setting, contact_email: "invalid")
    setting.save

    expected_error = "Contact email is invalid"

    assert_equal setting.errors.full_messages.to_sentence, expected_error
  end

  test "contact_email, meta_tags, meta_title and meta_description are required" do
    setting = build(
      :setting,
      contact_email: nil,
      meta_tags: nil,
      meta_title: nil,
      meta_description: nil
    )
    setting.save

    expected_error = "Contact email can't be blank, Meta tags can't be blank, " \
                     "Meta title can't be blank, Meta description can't be blank, " \
                     "and Contact email is invalid"

    assert_equal setting.errors.full_messages.to_sentence, expected_error
  end

  test "validate image_format" do
    filename = "empty_file.txt"
    file = File.open(Rails.root.join("test/factories/attachments/#{filename}").to_s)
    image = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename)

    setting = build(:setting, logo: image, favicon: image)
    assert setting.invalid?
    assert setting.errors.added?(:logo, "needs to be an image")
    assert setting.errors.added?(:favicon, "needs to be an image")
  end
end
