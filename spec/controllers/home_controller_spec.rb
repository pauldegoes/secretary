require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    context 'when user is not signed in' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'renders the home page' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when user is signed in' do
      let(:user) { User.create!(username: 'johndoe', email: 'test@example.com', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123') }

      before do
        session[:user_id] = user.id
      end

      it 'redirects to dashboard' do
        get :index
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end
