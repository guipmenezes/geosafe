# frozen_string_literal: true

FactoryBot.define do
  factory :alert_vote do
    association :user
    association :alert
    vote_type { :relevant }
  end
end
