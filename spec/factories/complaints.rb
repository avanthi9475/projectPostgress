FactoryBot.define do
  factory :complaint do
    user_id { 1 }
    statement { "Missing my mobile phone" }
    location { "Chennai" }
    dateTime { "2023-05-24 14:49:28" }
    lead { 1 }
  end
end
