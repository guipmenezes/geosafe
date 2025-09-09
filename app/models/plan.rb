# frozen_string_literal: true

class Plan < ApplicationRecord
  has_many :plan_subscriptions
  has_many :users, through: :plan_subscriptions

  def price
    (BigDecimal(price_cents) / 100).round(2)
  end

  def formatted_price
    format('%.2f', price).tr('.', ',')
  end
end
