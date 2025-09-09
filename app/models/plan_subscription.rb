# frozen_string_literal: true

class PlanSubscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan
end
