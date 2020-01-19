class DiscussionsController < ApplicationController
  before_action :find_discussion, only: [:destroy, :edit, :update]
  before_action :description_params, only: [:create, :update]


    def create
        @project = Project.find(params[:project_id])
        @discussion = Discussion.new discussion_params
        @discussion.project = @project
        if @discussion.save
            flash[:notice] = 'Discussion created successfully'
            redirect_to project_path(@project)
        else
            @discussions = @project.discussions.order(created_at: :desc)
            render 'projects/show'    
        end
    end

    def edit
        @discussion = Discussion.find params[:id] 
        render :edit
    end

    def update
        @discussion = Discussion.find params[:id]
            if @discussion.update discussion_params
                flash[:notice] = 'Updated Successfully'
                redirect_to project_path(@discussion.project)
            else
                render :edit
            end
    end

    def destroy
        @discussion = Discussion.find(params[:id])
        @discussion.destroy 
        redirect_to project_path(@discussion.project)
    end

    private
    
    def find_discussion
        @discussion = Discussion.find params[:id]
    end

    def discussion_params
        params.require(:discussion).permit(:title, :description)
    end
end
