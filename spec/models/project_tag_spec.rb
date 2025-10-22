require 'rails_helper'

RSpec.describe ProjectTag, type: :model do
  let(:user) { User.create!(username: 'johndoe', email: 'test@example.com', first_name: 'John', last_name: 'Doe', provider: 'github', uid: '123') }
  let(:project) { Project.create!(name: 'Test Project', owner: 'John Doe', target_date: 1.week.from_now, user: user) }
  let(:tag) { Tag.create!(name: 'Q4', namespace: 'project_group') }

  describe 'validations' do
    it 'validates uniqueness of project_id scoped to tag_id' do
      ProjectTag.create!(project: project, tag: tag)
      duplicate = ProjectTag.new(project: project, tag: tag)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:project_id]).to include("has already been taken")
    end
  end

  describe 'associations' do
    it 'belongs to project' do
      project_tag = ProjectTag.create!(project: project, tag: tag)
      expect(project_tag.project).to eq(project)
    end

    it 'belongs to tag' do
      project_tag = ProjectTag.create!(project: project, tag: tag)
      expect(project_tag.tag).to eq(tag)
    end
  end
end
