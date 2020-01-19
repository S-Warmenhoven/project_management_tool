class ProjectsController < ApplicationController

    before_action :authenticate_user!, except: [:index, :show]
    before_action :find_project, only: [:edit, :update, :show, :destroy]
    before_action :project_params, only: [:create, :update]
    
    def index
        @projects = Project.all.order(created_at: :desc)
    end

    def new
        @project = Project.new 
    end

    def create
        @project = Project.new project_params
        @project.user = current_user
        if @project.save
            flash[:notice] = 'Project added successfully'
            redirect_to project_path(@project)
        else
            render :new
        end
    end

    def show
        @task = Task.new
        @tasks = @project.tasks
        @discussion = Discussion.new
        @discussions = @project.discussions
        @comment = Comment.new
        @comments = @discussion.comments
    end

    def edit
    end

    def update
        if @project.update project_params
            flash[:notice] = 'Updated Project Successfully'
            redirect_to project_path(@project)
        else
            render :edit
        end 
    end

    def destroy
        @project.destroy
        flash[:danger] = 'Project Deleted'
        redirect_to projects_path
    end

    private

    def project_params
        params.require(:project).permit(:title, :description, :due_date)
    end

    def find_project
        @project = Project.find params[:id]
    end

    def authorize!
        redirect_to root_path, alert: "Access Denied" unless can? :crud, @project
    end

end
