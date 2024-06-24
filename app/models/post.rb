class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: %i(slugged finders)

  has_one_attached :image

  validates :title, :body, presence: true
  validates_with ImageFormatValidator, image_fields: %i(image)
end
