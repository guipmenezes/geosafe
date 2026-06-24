# frozen_string_literal: true

class Alert < ApplicationRecord
  self.inheritance_column = :_type_disabled # Disable STI

  include TypeCodes
  include AlertCodes
  include AlertGeocoding

  belongs_to :user
  has_many :alert_votes, dependent: :destroy

  after_create_commit -> { broadcast_prepend_to 'alerts', target: 'alerts', partial: 'home/alert_card', locals: { alert: self } }
  after_create_commit :notify_users_in_interest_zones

  validates :alert, presence: true, inclusion: { in: [HOME, STREET] }
  validates :location, presence: true, if: :street_alert?
  validates :alert_type, presence: true, inclusion: { in: [GOOD, ALERT, DANGER] }
  validates :user_id, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validate :user_has_address, if: :home_alert?

  before_validation :set_coordinates, if: :home_alert?
  geocoded_by :location
  after_validation :geocode, if: :street_alert_and_location_changed?
  after_validation :reverse_geocode_location, if: :should_reverse_geocode?

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

  def home_alert?
    alert == HOME
  end

  def street_alert?
    alert == STREET
  end

  def as_json_for_map
    {
      id: id,
      latitude: latitude,
      longitude: longitude,
      title: title,
      description: description,
      location: location,
      alert_name: alert_name,
      alert_type_name: alert_type_name,
      alert_type: alert_type,
      user_id: user_id,
      creator_name: user.full_name,
      date: I18n.l(created_at, format: :short),
      timestamp: created_at.to_i
    }
  end

  private

  def notify_users_in_interest_zones
    return unless alert_type == DANGER

    # Raio de 5km para notificações preventivas
    radius = 5

    # Busca os IDs de usuários que têm endereços próximos, ignorando a ordenação por distância
    # que causa o erro com pluck/uniq em algumas situações
    target_user_ids = Address.near([latitude, longitude], radius)
                             .where.not(user_id: user_id)
                             .reorder(nil) # Remove o ORDER BY distance
                             .distinct
                             .pluck(:user_id)

    target_user_ids.each do |target_user_id|
      Notification.create(user_id: target_user_id, alert: self)
    end
  end

  def user_has_address
    return errors.add(:base, 'Você precisa ter um endereço cadastrado para criar um alerta residencial.') if user&.address.nil?

    ensure_user_address_geocoded
    return if user.address.latitude.present? && user.address.longitude.present?

    errors.add(:base, 'Seu endereço cadastrado não pôde ser localizado no mapa. Por favor, verifique se o CEP e o número estão corretos.')
  end

  def ensure_user_address_geocoded
    user.address.geocode_address if user.address.latitude.blank? || user.address.longitude.blank?
  end

  def should_reverse_geocode?
    street_alert? && latitude.present? && longitude.present? && (location.blank? || location.start_with?('Coordenadas:'))
  end

  def street_alert_and_location_changed?
    street_alert? && location_changed? && (latitude.blank? || longitude.blank?)
  end

  def set_coordinates
    return unless user&.address

    ensure_user_address_geocoded
    self.latitude = user.address.latitude
    self.longitude = user.address.longitude
    self.location = user.address.anonymized_address
  end
end
