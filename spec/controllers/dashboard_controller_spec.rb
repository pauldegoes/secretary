require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) { User.create!(username: 'johndoe', email: 'test@example.com', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123') }

  before do
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'assigns user projects' do
      project = Project.create!(name: 'Test Project', owner: 'John Doe', target_date: 1.week.from_now, user: user)
      get :index
      expect(assigns(:projects)).to include(project)
    end

    it 'assigns project groups' do
      project = Project.create!(name: 'Test Project', owner: 'John Doe', target_date: 1.week.from_now, user: user)
      project.add_project_group('Q4')
      get :index
      expect(assigns(:project_groups)).to be_present
    end
  end
end
