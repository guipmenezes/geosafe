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
  has_many :addresses, dependent: :destroy
  has_many :interest_zones, dependent: :destroy
  has_many :push_subscriptions, dependent: :destroy
  has_many :plan_subscriptions
  has_many :plans, through: :plan_subscriptions
  has_many :alerts, dependent: :destroy
  has_many :alert_votes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # Legacy compatibility after has_one :address -> has_many :addresses change
  def address
    addresses.first
  end

  # Limit to 3 addresses (Interest Zones)
  validate :validate_addresses_count

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
    return 'Bronze' if geopoints.to_i < 100
    return 'Prata' if geopoints.to_i < 500
    return 'Ouro' if geopoints.to_i < 1000

    'Verificado'
  end

  def badge_color
    {
      'Bronze' => 'bg-amber-100 text-amber-800',
      'Prata' => 'bg-slate-200 text-slate-800',
      'Ouro' => 'bg-yellow-100 text-yellow-800',
      'Verificado' => 'bg-blue-100 text-blue-800'
    }[level]
  end

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  private

  def validate_addresses_count
    return unless addresses.size > 3

    errors.add(:addresses, 'Você pode cadastrar no máximo 3 zonas de interesse.')
  end

  def password_matches_confirmation
    return if password.blank? || password_confirmation.blank?
    return if password == password_confirmation

    errors.add(:password_confirmation, 'deve ser igual à senha')
  end
end
