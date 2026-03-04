# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    full_name { 'John Doe' }
    sequence(:username) { |n| "john_doe_#{n}" }
    sequence(:email) { |n| "person#{n}@example.com" }
    password { 'Secret1*3*5*' }
    password_confirmation { 'Secret1*3*5*' }
    verified { true }
    geopoints { 100 }
  end
end
