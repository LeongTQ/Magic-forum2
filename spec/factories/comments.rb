FactoryGirl.define do
  factory :comment do

    body "Comment body and others"

    post_id { create(:post).id }
    user_id { create(:user, :sequenced_username, :sequenced_email).id }

    trait :sequenced_body do
      sequence(:body) { |n| "i need a long body for my comments_#{n}" }
      #note that the description here will overwrite the description in the above.
    end
  end
end
