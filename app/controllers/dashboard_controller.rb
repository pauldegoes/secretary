class DashboardController < ApplicationController
  def index
    @projects = current_user.projects.includes(:tags).order(:created_at)
    @project_groups = Tag.project_groups.joins(:projects).where(projects: { user: current_user }).distinct
  end
end
