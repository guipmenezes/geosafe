# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PushSubscription, type: :model do
  describe 'associations' do
    it 'belongs to user' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
