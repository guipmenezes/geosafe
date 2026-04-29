# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Alert, type: :model do
  let(:user) do
    User.create!(email: 'test@example.com', password: 'Password123!', password_confirmation: 'Password123!', full_name: 'Test User',
                 username: 'testuser')
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      alert = Alert.new(
        title: 'Title',
        description: 'Description',
        location: 'Location',
        alert_type: TypeCodes::GOOD,
        alert: AlertCodes::HOME,
        user: user
      )
      expect(alert).to be_valid
    end

    it 'is invalid without title' do
      alert = Alert.new(title: nil)
      alert.valid?
      expect(alert.errors[:title]).to include('não pode ficar em branco')
    end

    it 'is invalid without description' do
      alert = Alert.new(description: nil)
      alert.valid?
      expect(alert.errors[:description]).to include('não pode ficar em branco')
    end

    it 'is valid without location if it is a HOME alert' do
      alert = Alert.new(
        title: 'Home Alert',
        description: 'Testing',
        alert_type: TypeCodes::GOOD,
        alert: AlertCodes::HOME,
        user: user
      )
      expect(alert).to be_valid
    end

    it 'is invalid without location if it is a STREET alert' do
      alert = Alert.new(
        title: 'Street Alert',
        description: 'Testing',
        alert_type: TypeCodes::GOOD,
        alert: AlertCodes::STREET,
        user: user,
        location: nil
      )
      alert.valid?
      expect(alert.errors[:location]).to include('não pode ficar em branco')
    end
  end

  describe 'coordinates' do
    let(:address) do
      Address.create!(
        user: user,
        cep: '12345-678',
        uf: 'SP',
        city: 'São Paulo',
        state: 'São Paulo',
        address: 'Rua Teste',
        number: '123',
        latitude: -23.5505,
        longitude: -46.6333
      )
    end

    it 'sets coordinates and location from user address for HOME alerts' do
      address # trigger creation
      alert = Alert.new(
        title: 'Home Alert',
        description: 'Testing home alert',
        alert_type: TypeCodes::GOOD,
        alert: AlertCodes::HOME,
        user: user
      )

      alert.valid?
      expect(alert.latitude).to eq(address.latitude)
      expect(alert.longitude).to eq(address.longitude)
      expect(alert.location).to eq(address.full_address)
    end
  end
end
