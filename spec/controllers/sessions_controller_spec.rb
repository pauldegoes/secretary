require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { User.create!(username: 'johndoe', email: 'test@example.com', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123') }

  before do
    session[:user_id] = user.id
  end

  describe 'DELETE #destroy' do
    it 'clears the session' do
      expect(session[:user_id]).to eq(user.id)
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to root path' do
      delete :destroy
      expect(response).to redirect_to(root_path)
    end

    it 'sets success notice' do
      delete :destroy
      expect(flash[:notice]).to eq('Successfully signed out!')
    end
  end
end
