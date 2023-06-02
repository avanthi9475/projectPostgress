FactoryBot.define do
  factory :message do
    complaint

    statement { "Please update about my complaint status" }
    dateTime { "2023-05-24 16:39:51" }
    for_user

    trait :for_user do
      association :message, factory: :user
      statement { "Please update about my complaint status" }
    end

    trait :for_officer do
      association :message, factory: :officer
      statement { "The process is ongoing" }
    end

  end
end
