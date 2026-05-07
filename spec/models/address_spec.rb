# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:user) do
    User.create!(email: 'test@example.com', password: 'Password123!', password_confirmation: 'Password123!', full_name: 'Test User',
                 username: 'testuser')
  end

  describe '#full_address' do
    it 'returns a formatted address string' do
      address = Address.new(
        user: user,
        cep: '12345-678',
        uf: 'SP',
        city: 'São Paulo',
        state: 'São Paulo',
        address: 'Rua Teste',
        number: '123'
      )
      expect(address.full_address).to eq('Rua Teste, 123, São Paulo - SP')
    end
  end
end
