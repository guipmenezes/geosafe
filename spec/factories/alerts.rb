# frozen_string_literal: true

FactoryBot.define do
  factory :alert do
    association :user
    type { 1 }
    alert { 1 }
    location { 'Sample Location' }
    resident { false }
    relevant { 0 }
    inappropriate { 0 }
  end
end
