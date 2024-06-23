class User < ApplicationRecord
  has_one_attached :avatar

  devise :database_authenticatable, :rememberable, :validatable

  def full_name
    [first_name, last_name].join(" ")
  end
end
