FactoryGirl.define do
  factory :event do
    user_id 1
    name "my name"
    description "the description"
    location "London"
    duration nil
    removed false
    start_date Date.today
    end_date Date.tomorrow
  end
end
