class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_comment, only: [:destroy, :edit, :update]
    before_action :comment_params, only: [:create, :update]


    def create
        @discussion = Discussion.find(params[:discussion_id])
        @comment = Comment.new comment_params
        @comment.user = current_user
        @comment.discussion = @discussion
        if @comment.save
            flash[:notice] = 'Comment created successfully'
            redirect_to discussion_path(@discussion)
        else
            @comments = @discussion.comments.order(created_at: :desc)
            render 'projects/show'    
        end
    end

    def edit
        render :edit
    end

    def update
            if @comment.update comment_params
                flash[:notice] = 'Updated Successfully'
                redirect_to discussion_path(@comment.discussion)
            else
                render :edit
            end
    end

    def destroy
        @comment.destroy 
        redirect_to discussion_path(@comment.discussion)
    end

    private
    
    def find_comment
        @comment = Comment.find params[:id]
    end

    def comment_params
        params.require(:comment).permit(:body)
    end
end