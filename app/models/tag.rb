class Tag < ApplicationRecord
  has_many :project_tags, dependent: :destroy
  has_many :projects, through: :project_tags

  validates :name, presence: true
  validates :namespace, presence: true
  validates :name, uniqueness: { scope: :namespace }

  scope :project_groups, -> { where(namespace: 'project_group') }
  scope :by_namespace, ->(namespace) { where(namespace: namespace) }

  def self.find_or_create_project_group(name)
    find_or_create_by(name: name, namespace: 'project_group')
  end
end
