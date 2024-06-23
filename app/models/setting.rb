class Setting < ApplicationRecord
  self.table_name = "settings"

  has_one_attached :favicon
  has_one_attached :logo

  validates :contact_email, :meta_tags, :meta_title, :meta_description, presence: true
  validates :contact_email, format: { with: Devise.email_regexp }, allow_nil: false
  validate :single_setting

  private

  def single_setting
    errors.add :base, "Only 1 instance of Setting is allowed" if Setting.any?
  end
end
