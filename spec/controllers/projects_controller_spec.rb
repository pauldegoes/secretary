require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { User.create!(username: 'johndoe', email: 'test@example.com', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123') }
  let(:project) { Project.create!(name: 'Test Project', owner: 'John Doe', target_date: 1.week.from_now, user: user) }

  before do
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'assigns user projects' do
      get :index
      expect(assigns(:projects)).to eq(user.projects)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: project.id }
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested project' do
      get :show, params: { id: project.id }
      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new project' do
      get :new
      expect(assigns(:project)).to be_a_new(Project)
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        project: {
          name: 'New Project',
          owner: 'John Doe',
          target_date: 2.weeks.from_now
        },
        project_group: 'Q4'
      }
    end

    it 'creates a new project' do
      expect {
        post :create, params: valid_params
      }.to change(Project, :count).by(1)
    end

    it 'redirects to the project' do
      post :create, params: valid_params
      expect(response).to redirect_to(Project.last)
    end

    it 'creates project group tag if provided' do
      post :create, params: valid_params
      expect(Tag.find_by(name: 'Q4', namespace: 'project_group')).to be_present
    end
  end

  describe 'PATCH #update' do
    let(:update_params) do
      {
        id: project.id,
        project: {
          name: 'Updated Project',
          owner: 'Jane Doe'
        }
      }
    end

    it 'updates the project' do
      patch :update, params: update_params
      project.reload
      expect(project.name).to eq('Updated Project')
      expect(project.owner).to eq('Jane Doe')
    end

    it 'redirects to the project' do
      patch :update, params: update_params
      expect(response).to redirect_to(project)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the project' do
      project_id = project.id
      expect(Project.find_by(id: project_id)).to be_present
      
      expect {
        delete :destroy, params: { id: project.id }
      }.to change(Project, :count).by(-1)
      
      expect(Project.find_by(id: project_id)).to be_nil
    end

    it 'redirects to projects index' do
      delete :destroy, params: { id: project.id }
      expect(response).to redirect_to(projects_path)
    end
  end
end
