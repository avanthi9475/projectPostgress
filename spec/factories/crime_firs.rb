FactoryBot.define do
  factory :crime_fir do
    user_id { 1 }
    complaint_id { 1 }
    under_section { 302 }
    crime_category { "MyString" }
    dateTime_of_crime { "2023-05-24 14:53:52" }
  end
end
