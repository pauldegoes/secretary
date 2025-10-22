require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'validates presence of username' do
      user = User.new(email: 'test@example.com', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123')
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'validates presence of email' do
      user = User.new(username: 'johndoe', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'validates uniqueness of email' do
      User.create!(username: 'johndoe', email: 'test@example.com', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123')
      user = User.new(username: 'jane', email: 'test@example.com', first_name: 'Jane', last_name: 'Doe', provider: 'github', uid: '456')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it 'validates uniqueness of provider and uid combination' do
      User.create!(username: 'johndoe', email: 'test@example.com', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123')
      user = User.new(username: 'jane', email: 'jane@example.com', first_name: 'Jane', last_name: 'Doe', provider: 'github', uid: '123')
      expect(user).not_to be_valid
      expect(user.errors[:uid]).to include("has already been taken")
    end
  end

  describe 'associations' do
    it 'has many projects' do
      user = User.create!(username: 'johndoe', email: 'test@example.com', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123')
      expect(user).to respond_to(:projects)
    end

    it 'has many user_logins' do
      user = User.create!(username: 'johndoe', email: 'test@example.com', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123')
      expect(user).to respond_to(:user_logins)
    end

    it 'has one attached photo' do
      user = User.create!(username: 'johndoe', email: 'test@example.com', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123')
      expect(user).to respond_to(:photo)
    end
  end

  describe 'methods' do
    let(:user) { User.create!(username: 'johndoe', email: 'test@example.com', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123') }

    it 'returns full name' do
      expect(user.full_name).to eq('John Doe')
    end

    it 'creates user from omniauth hash' do
      auth_hash = {
        'provider' => 'github',
        'uid' => '789',
        'info' => {
          'name' => 'Jane Smith',
          'email' => 'jane@example.com',
          'nickname' => 'janesmith'
        }
      }

      # Mock the OmniAuth object
      auth = double('auth')
      allow(auth).to receive(:provider).and_return('github')
      allow(auth).to receive(:uid).and_return('789')
      allow(auth).to receive(:info).and_return(double(
        email: 'jane@example.com',
        nickname: 'janesmith',
        first_name: 'Jane',
        last_name: 'Smith',
        name: 'Jane Smith'
      ))

      user = User.from_omniauth(auth)
      expect(user).to be_persisted
      expect(user.username).to eq('janesmith')
      expect(user.email).to eq('jane@example.com')
      expect(user.first_name).to eq('Jane')
      expect(user.last_name).to eq('Smith')
      expect(user.provider).to eq('github')
      expect(user.uid).to eq('789')
    end
  end
end
