# frozen_string_literal: true

class Alert < ApplicationRecord
  self.inheritance_column = :_type_disabled # Disable STI

  include TypeCodes
  include AlertCodes

  belongs_to :user
  has_many :alert_votes, dependent: :destroy

  validates :alert, presence: true, inclusion: { in: [HOME, STREET] }
  validates :location, presence: true
  validates :alert_type, presence: true, inclusion: { in: [GOOD, ALERT, DANGER] }
  validates :user_id, presence: true
  validates :title, presence: true
  validates :description, presence: true

  def user_vote(user)
    alert_votes.find_by(user: user)
  end

  def self.alert_type_options
    { 'Seguro' => GOOD, 'Atenção' => ALERT, 'Perigo' => DANGER }
  end

  def self.alert_options
    { 'Residencial' => HOME, 'Na Rua' => STREET }
  end

  def alert_type_name
    self.class.alert_type_options.key(alert_type)
  end

  def alert_name
    self.class.alert_options.key(alert)
  end
end
