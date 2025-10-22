require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      tag = Tag.new(namespace: 'project_group')
      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of namespace' do
      tag = Tag.new(name: 'Q4')
      expect(tag).not_to be_valid
      expect(tag.errors[:namespace]).to include("can't be blank")
    end

    it 'validates uniqueness of name scoped to namespace' do
      Tag.create!(name: 'Q4', namespace: 'project_group')
      tag = Tag.new(name: 'Q4', namespace: 'project_group')
      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to include("has already been taken")
    end
  end

  describe 'associations' do
    it 'has many project_tags' do
      tag = Tag.create!(name: 'Q4', namespace: 'project_group')
      expect(tag).to respond_to(:project_tags)
    end

    it 'has many projects through project_tags' do
      tag = Tag.create!(name: 'Q4', namespace: 'project_group')
      expect(tag).to respond_to(:projects)
    end
  end

  describe 'scopes' do
    let!(:project_group_tag) { Tag.create!(name: 'Q4', namespace: 'project_group') }
    let!(:other_tag) { Tag.create!(name: 'urgent', namespace: 'priority') }

    it 'finds project group tags' do
      expect(Tag.project_groups).to include(project_group_tag)
      expect(Tag.project_groups).not_to include(other_tag)
    end

    it 'finds tags by namespace' do
      expect(Tag.by_namespace('project_group')).to include(project_group_tag)
      expect(Tag.by_namespace('project_group')).not_to include(other_tag)
    end
  end

  describe 'class methods' do
    it 'finds or creates project group' do
      tag = Tag.find_or_create_project_group('Q4')
      expect(tag.name).to eq('Q4')
      expect(tag.namespace).to eq('project_group')
      expect(tag).to be_persisted

      # Should return the same tag if called again
      same_tag = Tag.find_or_create_project_group('Q4')
      expect(same_tag).to eq(tag)
    end
  end
end
