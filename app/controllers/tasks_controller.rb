class TasksController < ApplicationController

    before_action :authenticate_user!
    before_action :find_task, only: [:edit, :update]
    before_action :task_params, only: [:create, :update]


    def create
        @project = Project.find(params[:project_id])
        @task = Task.new task_params
        @task.user = current_user
        @task.project = @project
        if @task.save
            flash[:notice] = 'Task created successfully'
            redirect_to project_path(@project)
        else
            @tasks = @project.tasks
            render 'projects/show'    
        end
    end

    def update
        if !@task.update(is_done: params[:is_done])
          flash[:alert] = @task.errors.full_messages.join(', ')
        end
        redirect_to @task.project
    end
    

    private
    
    def find_task
        @task = Task.find params[:id]
    end

    def task_params
        params.require(:task).permit(:title, :due_date, :is_done)
    end
end


    
  
    
  
    
  
    
