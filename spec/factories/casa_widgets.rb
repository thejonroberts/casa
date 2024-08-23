FactoryBot.define do
  factory :casa_widget do
    name { "MyString" }
    body { "MyText" }
    hidden { false }
    amount { "9.99" }
    tracking_id { 1 }
    email { "MyString" }
    password { "" }
  end
end
