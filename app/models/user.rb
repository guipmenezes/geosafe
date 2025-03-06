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

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 12 }
  validates :password_confirmation, presence: true, if: :password_digest_changed?
  validate :password_matches_confirmation
  validates :full_name, presence: true, length: { minimum: 3, maximum: 100 }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 },
                      format: { with: /\A[a-zA-Z0-9_]+\z/, message: "apenas permite letras, números e underline" }

  normalizes :email, with: -> { _1.strip.downcase }
  normalizes :username, with: -> { _1.strip.downcase }
  normalizes :full_name, with: -> { _1.strip }

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
    errors.add(:password_confirmation, "deve ser igual à senha")
  end
end
