FactoryBot.define do
  factory :complaint do
    user

    statement { "Please update about my complaint status" }
    location { "Chennai" }
    dateTime { "2023-05-24 16:03:08" }
    leadOfficerID { 1 }
  end
end
