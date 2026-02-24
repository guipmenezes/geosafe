# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AlertVote, type: :model do
  describe 'associations' do
    it 'belongs to user' do
      vote = build(:alert_vote)
      expect(vote.user).to be_a(User)
    end

    it 'belongs to alert' do
      vote = build(:alert_vote)
      expect(vote.alert).to be_a(Alert)
    end
  end

  describe 'validations' do
    it 'validates uniqueness of user_id scoped to alert_id' do
      user = create(:user)
      alert = create(:alert)
      create(:alert_vote, user: user, alert: alert)

      duplicate_vote = build(:alert_vote, user: user, alert: alert)
      expect(duplicate_vote).not_to be_valid
    end

    it 'validates presence of vote_type' do
      vote = build(:alert_vote, vote_type: nil)
      expect(vote).not_to be_valid
    end
  end

  describe 'callbacks' do
    let(:alert) { create(:alert) }

    it 'updates alert counters after save' do
      expect do
        create(:alert_vote, alert: alert, vote_type: :relevant)
      end.to change { alert.reload.relevant }.by(1)
    end

    it 'updates alert counters after destroy' do
      vote = create(:alert_vote, alert: alert, vote_type: :inappropriate)
      expect do
        vote.destroy
      end.to change { alert.reload.inappropriate }.by(-1)
    end
  end
end
