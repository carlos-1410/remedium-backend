FactoryBot.define do
  factory :user do
    trait :admin do
      email { "admin@remedium.band" }
      password { "passwd" }
      password_confirmation { "passwd" }
      first_name { "Administrator" }
      last_name { "Systemu" }
      admin { true }
    end
  end
end
