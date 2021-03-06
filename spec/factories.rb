FactoryGirl.define do  
  
  factory :user, aliases: [:author] do
    facebook_name "John Doe"
    facebook_id "123456789"

    factory :user_with_devices do
      transient do
        devices_count 1
      end
      after(:create) do |user, evaluator|
        create_list(:device, evaluator.devices_count, user: user)
      end
    end

    factory :user_authenticated do
      sequence(:access_token) { |n| "VALID_ACCESS_TOKEN#{n}" }
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

    factory :challenge_with_pictures do
      transient do
        pictures_count 1
      end
      after(:create) do |challenge, evaluator|
        create_list(:picture, evaluator.pictures_count, challenge: challenge)
      end
    end

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