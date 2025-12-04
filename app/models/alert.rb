# frozen_string_literal: true

class Alert < ApplicationRecord
  belongs_to :user, dependent: :destroy

  validates :alert, presence: true
  validates :location, presence: true
end
