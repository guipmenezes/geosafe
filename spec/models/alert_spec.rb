require 'rails_helper'

RSpec.describe Alert, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'Password123!', password_confirmation: 'Password123!', full_name: 'Test User', username: 'testuser') }
  
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
      expect(alert.errors[:title]).to include("não pode ficar em branco")
    end

    it 'is invalid without description' do
      alert = Alert.new(description: nil)
      alert.valid?
      expect(alert.errors[:description]).to include("não pode ficar em branco")
    end
  end
end
