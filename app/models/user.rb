# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  generates_token_for :email_verification, expires_in: 2.days do
    email
  end
  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end

  has_many :sessions, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :plan_subscriptions
  has_many :plans, through: :plan_subscriptions
  has_many :alerts, dependent: :destroy
  has_many :alert_votes, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 12 },
                       format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s]).{12,}\z/,
                                 message: 'deve conter pelo menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial' }
  validates :password_confirmation, presence: true, if: :password_digest_changed?
  validate :password_matches_confirmation
  validates :full_name, presence: true, length: { minimum: 3, maximum: 100 }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: 'apenas permite letras, números e underline' }

  normalizes :email, with: -> { _1.strip.downcase }
  normalizes :username, with: -> { _1.strip.downcase }
  normalizes :full_name, with: lambda(&:strip)

  def level
    return "Iniciante" if geopoints.to_i < 100
    return "Explorador" if geopoints.to_i < 500
    return "Protetor" if geopoints.to_i < 1000
    "Embaixador"
  end

  def badge_color
    case level
    when "Iniciante" then "bg-gray-100 text-gray-800"
    when "Explorador" then "bg-blue-100 text-blue-800"
    when "Protetor" then "bg-green-100 text-green-800"
    when "Embaixador" then "bg-purple-100 text-purple-800"
    end
  end

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  private

  def password_matches_confirmation
    return if password.blank? || password_confirmation.blank?
    return if password == password_confirmation

    errors.add(:password_confirmation, 'deve ser igual à senha')
  end
end
