FactoryGirl.define do
  factory :topic do
    title "Topic"
    description "Topic Description and others"
    user_id { create(:user, :admin).id }

    trait :sequenced_title do
      sequence(:title) { |n| "title_#{n}" }
    end

    trait :sequenced_description do
      sequence(:description) { |n| "i need to be a much longer description_#{n}" }
      #note that the description here will overwrite the description in the above.
    end
  end
end
