FactoryBot.define do
  factory :officers_complaint do
    officer
    complaint

    IsHead { "No" }
  end
end
