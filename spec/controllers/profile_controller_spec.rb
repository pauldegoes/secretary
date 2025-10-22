require 'rails_helper'

RSpec.describe ProfileController, type: :controller do
  let(:user) { User.create!(username: 'johndoe', email: 'test@example.com', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123') }

  before do
    session[:user_id] = user.id
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show
      expect(response).to have_http_status(:success)
    end

    it 'assigns the current user' do
      get :show
      expect(assigns(:user)).to eq(user)
    end

    it 'assigns login history' do
      UserLogin.create!(user: user, ip_address: '127.0.0.1', signed_in_at: Time.current)
      get :show
      expect(assigns(:login_history)).to be_present
    end
  end

  describe 'PATCH #update' do
    context 'with valid photo' do
      let(:photo_file) { fixture_file_upload('spec/fixtures/test_image.jpg', 'image/jpeg') }

      before do
        # Create a test image file
        FileUtils.mkdir_p('spec/fixtures')
        File.write('spec/fixtures/test_image.jpg', 'fake image data')
      end

      after do
        FileUtils.rm_f('spec/fixtures/test_image.jpg')
      end

      it 'updates the user photo' do
        patch :update, params: { user: { photo: photo_file } }
        expect(response).to redirect_to(profile_path)
        expect(flash[:notice]).to eq('Profile photo updated successfully!')
      end
    end

    context 'with invalid parameters' do
      it 'redirects with error message' do
        patch :update, params: { user: { invalid_param: 'value' } }
        expect(response).to redirect_to(profile_path)
        expect(flash[:alert]).to eq('No photo selected.')
      end
    end
  end
end
