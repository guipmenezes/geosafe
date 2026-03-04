# frozen_string_literal: true

FactoryBot.define do
  factory :alert do
    association :user
    alert_type { TypeCodes::GOOD }
    alert { AlertCodes::HOME }
    title { 'Sample Alert Title' }
    description { 'This is a sample alert description for testing purposes.' }
    location { 'Sample Location' }
    relevant { 0 }
    inappropriate { 0 }
  end
end
