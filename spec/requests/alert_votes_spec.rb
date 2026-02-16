# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AlertVotes', type: :request do
  let(:user) { create(:user) }
  let(:alert) { create(:alert) }

  before do
    sign_in user
  end

  describe 'POST /alerts/:alert_id/votes' do
    context 'when user has not voted yet' do
      it 'creates a new vote' do
        expect {
          post alert_votes_path(alert), params: { vote_type: 'relevant' }
        }.to change(AlertVote, :count).by(1)
      end

      it 'responds with turbo stream' do
        post alert_votes_path(alert), params: { vote_type: 'relevant' }, as: :turbo_stream
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end
    end

    context 'when user has already voted with same type' do
      before { create(:alert_vote, user: user, alert: alert, vote_type: :relevant) }

      it 'removes the existing vote' do
        expect {
          post alert_votes_path(alert), params: { vote_type: 'relevant' }
        }.to change(AlertVote, :count).by(-1)
      end
    end

    context 'when user has already voted with different type' do
      before { create(:alert_vote, user: user, alert: alert, vote_type: :inappropriate) }

      it 'updates the vote type' do
        post alert_votes_path(alert), params: { vote_type: 'relevant' }
        expect(alert.alert_votes.find_by(user: user).vote_type).to eq('relevant')
      end

      it 'updates alert counters correctly' do
        post alert_votes_path(alert), params: { vote_type: 'relevant' }
        alert.reload
        expect(alert.relevant).to eq(1)
        expect(alert.inappropriate).to eq(0)
      end
    end
  end
end
