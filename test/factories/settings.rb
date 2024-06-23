FactoryBot.define do
  factory :setting do
    ga_tracking_id { "GA-xxx" }
    contact_email { "contact@email.com" }
    contact_phone { "123456789" }
    meta_title { "Meta title" }
    meta_tags { "tag1,tag2,tag3" }
    meta_description { "Meta description" }
    facebook_url { "https://facebook.com" }
    instagram_url { "https://instagram.com" }
    youtube_url { "https://youtube.com" }
  end
end
