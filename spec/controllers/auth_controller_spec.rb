require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  describe 'GET #passthru' do
    it 'redirects to GitHub OAuth for github provider' do
      get :passthru, params: { provider: 'github' }
      expect(response).to have_http_status(:redirect)
      expect(response.location).to include('github.com/login/oauth/authorize')
      expect(response.location).to include('client_id=Ov23lizimON5QMy8yTmC')
    end

    it 'redirects to root with alert for unsupported provider' do
      get :passthru, params: { provider: 'unsupported' }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Unsupported authentication provider.')
    end
  end

  describe 'GET #callback' do
    let(:auth_hash) do
      {
        'provider' => 'github',
        'uid' => '123456',
        'info' => {
          'name' => 'John Doe',
          'email' => 'john@example.com',
          'nickname' => 'johndoe'
        }
      }
    end

    before do
      # Mock the OmniAuth object
      auth = double('auth')
      allow(auth).to receive(:provider).and_return('github')
      allow(auth).to receive(:uid).and_return('123456')
      allow(auth).to receive(:info).and_return(double(
        email: 'john@example.com',
        nickname: 'johndoe',
        first_name: 'John',
        last_name: 'Doe',
        name: 'John Doe',
        image: nil
      ))
      
      request.env['omniauth.auth'] = auth
    end

    it 'creates a new user and redirects to dashboard' do
      expect {
        get :callback, params: { provider: 'github' }
      }.to change(User, :count).by(1)

      user = User.last
      expect(user.username).to eq('johndoe')
      expect(user.email).to eq('john@example.com')
      expect(user.provider).to eq('github')
      expect(user.uid).to eq('123456')

      expect(response).to redirect_to(dashboard_path)
    end

    it 'creates a user login record' do
      expect {
        get :callback, params: { provider: 'github' }
      }.to change(UserLogin, :count).by(1)

      login = UserLogin.last
      expect(login.user).to eq(User.last)
      expect(login.ip_address).to eq('0.0.0.0')
    end

    it 'sets session user_id' do
      get :callback, params: { provider: 'github' }
      expect(session[:user_id]).to eq(User.last.id)
    end
  end

  describe 'GET #failure' do
    it 'redirects to root with error message' do
      get :failure
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Authentication failed. Please try again.')
    end
  end
end
