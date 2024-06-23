FactoryBot.define do
  factory :post do
    title { "Example post #{random_chars}" }
    body { "This is post body" }
    tags { %w(example blog post) }
    meta_tags { %w(tag1 tag2 tag3) }
    slug { "example-post-#{random_chars}" }
    archived { false }
    visible_from { Time.zone.now }
    visible_to { 1.day.from_now }
    after(:create) do |post|
      post.image.attach(
        io: Rails.root.join("test/factories/attachments/avatar.jpeg").open,
        filename: "avatar.jpeg",
        content_type: "image/jpeg"
      )
    end
  end
end

def random_chars
  @random_chars ||= SecureRandom.hex(3)
end
