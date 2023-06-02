FactoryBot.define do
  factory :user_login do
    sequence :email do |n|
      "test#{n}@gmail.com"
    end
    password {123456}
    password_confirmation {123456}
    confirmed_at {Time.current}
    role {"user"}

  end
end
