FactoryBot.define do
  factory :crime_fir do
    user
    complaint
    
    under_section { 302 }
    crime_category { "Robery" }
    dateTime_of_crime { "2023-05-24 14:53:52" }
  end
end
