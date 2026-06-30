# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Addresses', type: :request do
  fixtures :users

  let(:user) { users(:lazaro_nixon) }

  before do
    sign_in(user)
  end

  describe 'GET /new' do
    it 'returns http success' do
      get new_address_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new address and redirects' do
        address_params = { label: 'Casa', cep: '12345-678', uf: 'SP', city: 'São Paulo', state: 'SP', address: 'Rua Teste', number: '123', complement: 'Apto 1' }
        expect do
          post addresses_path, params: { address: address_params }
        end.to change(Address, :count).by(1)
        expect(response).to redirect_to(home_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new address and re-renders the new template' do
        address_params = { cep: '' } # Invalid CEP
        expect do
          post addresses_path, params: { address: address_params }
        end.to_not change(Address, :count)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'GET /edit' do
    it 'returns http success' do
      address = user.addresses.create!(label: 'Casa', cep: '12345-678', uf: 'SP', city: 'São Paulo', state: 'SP', address: 'Rua Teste', number: '123')
      get edit_address_path(address)
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Meu Endereço')
    end
  end

  describe 'PATCH /update' do
    let!(:address) { user.addresses.create!(label: 'Casa', cep: '12345-678', uf: 'SP', city: 'São Paulo', state: 'SP', address: 'Rua Teste', number: '123') }

    context 'with valid parameters' do
      it 'updates the address and redirects' do
        patch address_path(address), params: { address: { number: '456' } }
        expect(address.reload.number).to eq(456)
        expect(response).to redirect_to(interest_zones_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the address and re-renders the edit template' do
        patch address_path(address), params: { address: { number: '' } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:address) { user.addresses.create!(label: 'Casa', cep: '12345-678', uf: 'SP', city: 'São Paulo', state: 'SP', address: 'Rua Teste', number: '123') }

    it 'deletes the address and redirects' do
      expect do
        delete address_path(address)
      end.to change(Address, :count).by(-1)
      expect(response).to redirect_to(interest_zones_path)
    end
  end
end
