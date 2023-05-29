FactoryBot.define do
  factory :status do
    status { "Inprogress" }
    for_complaint
    
    trait :for_complaint do
      association :statusable, factory: :complaint
      status {"Inprogress"}
    end

    trait :for_message do
      association :statusable, factory: :message
      status {"Pending"}
    end
  end
end
