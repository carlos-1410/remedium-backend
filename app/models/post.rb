class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: %i(slugged finders)

  has_one_attached :image

  validates :title, :body, presence: true
  validate :image_format

  def image_format
    return unless image.attached?
    return if image.blob.content_type.start_with? "image/"

    image.purge_later
    errors.add(:image, "needs to be an image")
  end
end
