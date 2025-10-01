# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Plans', type: :request do
  fixtures :users
  let(:user) { users(:lazaro_nixon) }

  before do
    sign_in(user)
  end

  describe 'GET /index' do
    it 'returns http success' do
      get plans_path
      expect(response).to have_http_status(:success)
    end
  end
end
