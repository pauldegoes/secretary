class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = current_user.projects.includes(:tags).order(:created_at)
  end

  def show
  end

  def new
    @project = current_user.projects.build
    @project_groups = Tag.project_groups.joins(:projects).where(projects: { user: current_user }).distinct
  end

  def create
    @project = current_user.projects.build(project_params)
    
    if @project.save
      # Add project group tag if provided
      if params[:project_group].present?
        @project.add_project_group(params[:project_group])
      end
      
      redirect_to @project, notice: 'Project was successfully created.'
    else
      @project_groups = Tag.project_groups.joins(:projects).where(projects: { user: current_user }).distinct
      render :new
    end
  end

  def edit
    @project_groups = Tag.project_groups.joins(:projects).where(projects: { user: current_user }).distinct
  end

  def update
    if @project.update(project_params)
      # Update project group tag if provided
      if params[:project_group].present?
        @project.project_tags.where(tag: Tag.project_groups).destroy_all
        @project.add_project_group(params[:project_group])
      end
      
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      @project_groups = Tag.project_groups.joins(:projects).where(projects: { user: current_user }).distinct
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully deleted.'
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :target_date, :owner)
  end
end
