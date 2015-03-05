FactoryGirl.define do
  
  factory :user, aliases: [:author] do
    first_name "John"
  end

  factory :picture do
    file_key "afilekey"
    picture_thread
    author
  end

  factory :picture_thread do
    title "My Challenge"
    lasting_time_type "s"
    author
  end

  factory :device do
    token "ADEVICETOKEN"
    user
  end

end