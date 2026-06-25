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
        category: CategoryCodes::SECURITY,
        alert: AlertCodes::STREET,
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

    it 'is valid without location if it is a HOME alert and user has address' do
      # Mock Geocoder to ensure it returns coordinates even in environments without external network
      result = instance_double(Geocoder::Result::Base, latitude: -23.5505, longitude: -46.6333)
      allow(result).to receive(:coordinates).and_return([-23.5505, -46.6333])
      allow(Geocoder).to receive(:search).and_return([result])

      Address.create!(
        user: user,
        cep: '01310-100',
        uf: 'SP',
        city: 'São Paulo',
        state: 'São Paulo',
        address: 'Rua Teste',
        number: '123',
        label: 'Casa'
      )
      alert = Alert.new(
        title: 'Home Alert',
        description: 'Testing',
        alert_type: TypeCodes::GOOD,
        category: CategoryCodes::SECURITY,
        alert: AlertCodes::HOME,
        user: user
      )
      expect(alert).to be_valid
    end

    it 'is invalid if it is a HOME alert and user has no address' do
      alert = Alert.new(
        title: 'Home Alert',
        description: 'Testing',
        alert_type: TypeCodes::GOOD,
        alert: AlertCodes::HOME,
        user: user
      )
      expect(alert).not_to be_valid
      expect(alert.errors.full_messages).to include('Você precisa ter um endereço cadastrado para criar um alerta residencial.')
    end

    it 'is invalid if it is a HOME alert and user address has no coordinates' do
      addr = Address.create!(
        user: user,
        cep: '00000-000',
        uf: 'XX',
        city: 'Nonexistent',
        state: 'Nonexistent',
        address: 'Nonexistent Street',
        number: '0',
        label: 'Casa'
      )
      # Mock Geocoder to return nothing for this address
      allow(Geocoder).to receive(:search).with(/Nonexistent Street/).and_return([])
      addr.update_columns(latitude: nil, longitude: nil)

      alert = Alert.new(
        title: 'Home Alert',
        description: 'Testing',
        alert_type: TypeCodes::GOOD,
        alert: AlertCodes::HOME,
        user: user
      )
      alert.valid?
      expect(alert).not_to be_valid
      expect(alert.errors.full_messages).to include('Seu endereço cadastrado não pôde ser localizado no mapa. Por favor, verifique se o CEP e o número estão corretos.')
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
        label: 'Casa',
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
      expect(alert.location).to eq(address.anonymized_address)
    end

    it 'overrides provided coordinates with user address for HOME alerts' do
      address # trigger creation
      alert = Alert.new(
        title: 'Home Alert',
        description: 'Testing home alert',
        alert_type: TypeCodes::GOOD,
        alert: AlertCodes::HOME,
        user: user,
        latitude: 10.0,
        longitude: 20.0,
        location: 'Other Location'
      )

      alert.valid?
      expect(alert.latitude).to eq(address.latitude)
      expect(alert.longitude).to eq(address.longitude)
      expect(alert.location).to eq(address.anonymized_address)
    end
  end

  describe 'reverse geocoding' do
    it 'strips plus codes and simplifies location' do
      alert = Alert.new(
        title: 'Street Alert',
        description: 'Testing',
        alert_type: TypeCodes::GOOD,
        alert: AlertCodes::STREET,
        user: user,
        latitude: -15.8333,
        longitude: -48.0667,
        location: 'Coordenadas: -15.8333, -48.0667'
      )

      # Mock Geocoder.search
      result = double('Geocoder::Result',
                      address: '6WHX+JQ Taguatinga, Brasília - DF',
                      data: {
                        'address_components' => [
                          { 'long_name' => 'Taguatinga', 'types' => ['sublocality'] },
                          { 'long_name' => 'Brasília', 'types' => ['locality'] },
                          { 'short_name' => 'DF', 'types' => ['administrative_area_level_1'] }
                        ]
                      })
      allow(Geocoder).to receive(:search).and_return([result])

      alert.valid? # Should trigger reverse_geocode_location via after_validation
      expect(alert.location).to eq('Taguatinga, Brasília')
    end

    it 'falls back to formatted address without plus code if components are missing' do
      alert = Alert.new(
        title: 'Street Alert',
        description: 'Testing',
        alert_type: TypeCodes::GOOD,
        alert: AlertCodes::STREET,
        user: user,
        latitude: -15.8333,
        longitude: -48.0667,
        location: ''
      )

      # Mock Geocoder.search with NO components
      result = double('Geocoder::Result',
                      address: '6WHX+JQ Taguatinga, Brasília - DF',
                      data: { 'address_components' => [] })
      allow(Geocoder).to receive(:search).and_return([result])

      alert.valid?
      expect(alert.location).to eq('Taguatinga, Brasília')
    end
  end
end
