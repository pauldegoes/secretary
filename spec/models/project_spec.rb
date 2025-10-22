require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { User.create!(username: 'johndoe', email: 'test@example.com', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123') }

  describe 'validations' do
    it 'validates presence of name' do
      project = Project.new(owner: 'John Doe', target_date: 1.week.from_now, user: user)
      expect(project).not_to be_valid
      expect(project.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of owner' do
      project = Project.new(name: 'Test Project', target_date: 1.week.from_now, user: user)
      expect(project).not_to be_valid
      expect(project.errors[:owner]).to include("can't be blank")
    end

    it 'validates uniqueness of name scoped to user' do
      Project.create!(name: 'Test Project', owner: 'John Doe', target_date: 1.week.from_now, user: user)
      project = Project.new(name: 'Test Project', owner: 'Jane Doe', target_date: 2.weeks.from_now, user: user)
      expect(project).not_to be_valid
      expect(project.errors[:name]).to include("has already been taken")
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      project = Project.create!(name: 'Test Project', owner: 'John Doe', target_date: 1.week.from_now, user: user)
      expect(project.user).to eq(user)
    end

    it 'has many project_tags' do
      project = Project.create!(name: 'Test Project', owner: 'John Doe', target_date: 1.week.from_now, user: user)
      expect(project).to respond_to(:project_tags)
    end

    it 'has many tags through project_tags' do
      project = Project.create!(name: 'Test Project', owner: 'John Doe', target_date: 1.week.from_now, user: user)
      expect(project).to respond_to(:tags)
    end
  end

  describe 'scopes' do
    let!(:upcoming_project) { Project.create!(name: 'Upcoming Project', owner: 'John Doe', target_date: 1.week.from_now, user: user) }
    let!(:overdue_project) { Project.create!(name: 'Overdue Project', owner: 'John Doe', target_date: 1.week.ago, user: user) }

    it 'finds upcoming projects' do
      expect(Project.upcoming).to include(upcoming_project)
      expect(Project.upcoming).not_to include(overdue_project)
    end

    it 'finds overdue projects' do
      expect(Project.overdue).to include(overdue_project)
      expect(Project.overdue).not_to include(upcoming_project)
    end

    it 'finds projects by user' do
      other_user = User.create!(username: 'janedoe', email: 'jane@example.com', first_name: 'Jane', last_name: 'Doe', provider: 'github', uid: '456')
      other_project = Project.create!(name: 'Other Project', owner: 'Jane Doe', target_date: 1.week.from_now, user: other_user)
      
      expect(Project.by_user(user)).to include(upcoming_project, overdue_project)
      expect(Project.by_user(user)).not_to include(other_project)
    end
  end

  describe 'methods' do
    let(:project) { Project.create!(name: 'Test Project', owner: 'John Doe', target_date: 1.week.from_now, user: user) }

    it 'returns project groups' do
      tag = Tag.create!(name: 'Q4', namespace: 'project_group')
      ProjectTag.create!(project: project, tag: tag)
      
      expect(project.project_groups).to include(tag)
    end

    it 'adds project group' do
      project.add_project_group('Q4')
      
      tag = Tag.find_by(name: 'Q4', namespace: 'project_group')
      expect(project.project_groups).to include(tag)
      expect(tag).to be_present
    end
  end
end
