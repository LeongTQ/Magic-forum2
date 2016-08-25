FactoryGirl.define do
  factory :post do
    title "Posts"
    body "Post body and others"

    topic_id { create(:topic).id }
    user_id { create(:user, :sequenced_username, :sequenced_email).id }

    trait :sequenced_title do
      sequence(:title) { |n| "title_#{n}" }
    end

    trait :sequenced_body do
      sequence(:body) { |n| "i need to be a much longer body_#{n}" }
      #note that the description here will overwrite the description in the above.
    end
  end
end
