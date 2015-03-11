FactoryGirl.define do
  
  factory :user, aliases: [:author] do
    first_name "John"

    factory :user_with_devices do
      transient do
        devices_count 1
      end
      after(:create) do |user, evaluator|
        create_list(:device, evaluator.devices_count, user: user)
      end
    end
  end

  factory :picture do
    file_key "afilekey"
    challenge
    author
  end

  factory :challenge do
    title "My Challenge"
    lasting_time_type "s"
    author
  end

  factory :device do
    token "ADEVICETOKEN"
    user
  end

  factory :comment do
    title "a comment"
    comment "this is my comment"
    association :commentable, factory: :picture
    commentable_type "Picture"
    association :user, factory: :user_with_devices
  end

end