# frozen_string_literal: true

FactoryBot.define do
  factory :alert do
    association :user
    alert_type { TypeCodes::GOOD }
    alert { AlertCodes::HOME }
    location { 'Sample Location' }
    relevant { 0 }
    inappropriate { 0 }
  end
end
