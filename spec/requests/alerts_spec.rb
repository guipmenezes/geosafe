# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Alerts', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_alert_url
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        { alert: {
          alert: AlertCodes::HOME,
          location: 'Test Location',
          alert_type: TypeCodes::GOOD,
          title: 'Test Title',
          description: 'Test Description'
        } }
      end

      it 'creates a new Alert' do
        expect do
          post alerts_url, params: valid_attributes
        end.to change(Alert, :count).by(1)
      end

      it 'redirects to the home page' do
        post alerts_url, params: valid_attributes
        expect(response).to redirect_to(home_path)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        { alert: { location: nil } }
      end

      it 'does not create a new Alert' do
        expect do
          post alerts_url, params: invalid_attributes
        end.to change(Alert, :count).by(0)
      end

      it "renders the 'new' template" do
        post alerts_url, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end
end
