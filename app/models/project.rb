class Project < ApplicationRecord
  belongs_to :user
  has_many :project_tags, dependent: :destroy
  has_many :tags, through: :project_tags

  validates :name, presence: true, uniqueness: { scope: :user }
  validates :owner, presence: true

  scope :by_user, ->(user) { where(user: user) }
  scope :upcoming, -> { where('target_date > ?', Time.current).order(:target_date) }
  scope :overdue, -> { where('target_date < ?', Time.current).order(:target_date) }

  def project_groups
    tags.where(namespace: 'project_group')
  end

  def add_project_group(group_name)
    tag = Tag.find_or_create_by(name: group_name, namespace: 'project_group')
    tags << tag unless tags.include?(tag)
  end
end
