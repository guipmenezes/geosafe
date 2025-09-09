# frozen_string_literal: true

class Plan < ApplicationRecord

  has_many :plan_subscriptions
  has_many :users, through: :plan_subscriptions
end
