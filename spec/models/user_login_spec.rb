require 'rails_helper'

RSpec.describe UserLogin, type: :model do
  let(:user) { User.create!(username: 'johndoe', email: 'test@example.com', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123') }

  describe 'validations' do
    it 'validates presence of ip_address' do
      login = UserLogin.new(user: user, signed_in_at: Time.current)
      expect(login).not_to be_valid
      expect(login.errors[:ip_address]).to include("can't be blank")
    end

    it 'validates presence of signed_in_at' do
      login = UserLogin.new(user: user, ip_address: '127.0.0.1')
      expect(login).not_to be_valid
      expect(login.errors[:signed_in_at]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      login = UserLogin.create!(user: user, ip_address: '127.0.0.1', signed_in_at: Time.current)
      expect(login.user).to eq(user)
    end
  end

  describe 'scopes' do
    let!(:recent_login) { UserLogin.create!(user: user, ip_address: '127.0.0.1', signed_in_at: 1.hour.ago) }
    let!(:old_login) { UserLogin.create!(user: user, ip_address: '127.0.0.1', signed_in_at: 1.month.ago) }

    it 'orders logins by signed_in_at desc' do
      recent_logins = UserLogin.recent
      expect(recent_logins.first).to eq(recent_login)
      expect(recent_logins.last).to eq(old_login)
    end
  end
end
