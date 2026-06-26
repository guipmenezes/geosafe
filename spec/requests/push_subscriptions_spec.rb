# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PushSubscriptions', type: :request do
  let(:user) { create(:user) }
  let(:valid_params) do
    {
      push_subscription: {
        endpoint: 'https://fcm.googleapis.com/fcm/send/test',
        p256dh: 'test_p256dh',
        auth: 'test_auth',
        user_agent: 'TestBrowser 1.0'
      }
    }
  end

  describe 'POST /push_subscriptions' do
    context 'when user is logged in' do
      before do
        sign_in(user)
      end

      it 'creates a new push subscription' do
        expect do
          post push_subscriptions_path, params: valid_params, as: :json
        end.to change(PushSubscription, :count).by(1)

        expect(response).to have_http_status(:created)
      end

      it 'updates existing subscription if endpoint is the same' do
        create(:push_subscription, user: user, endpoint: 'https://fcm.googleapis.com/fcm/send/test', auth: 'old_auth')

        expect do
          post push_subscriptions_path, params: valid_params, as: :json
        end.not_to change(PushSubscription, :count)

        expect(user.push_subscriptions.last.auth).to eq('test_auth')
        expect(response).to have_http_status(:created)
      end
    end

    context 'when user is not logged in' do
      it 'does not create a push subscription and returns unauthorized' do
        expect do
          post push_subscriptions_path, params: valid_params, as: :json
        end.not_to change(PushSubscription, :count)

        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'DELETE /push_subscriptions/:id' do
    let!(:subscription) { create(:push_subscription, user: user, endpoint: 'test_endpoint') }

    context 'when user is logged in' do
      before do
        sign_in(user)
      end

      it 'destroys the requested subscription' do
        expect do
          delete push_subscription_path('test_endpoint')
        end.to change(PushSubscription, :count).by(-1)

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
