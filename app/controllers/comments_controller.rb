class CommentsController < ApplicationController

  def index
    authorize! :manage, Comment
    @plans_with_outstanding_comments = Plan.with_outstanding_comments
  end

  def update
    authorize! :manage, Comment
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    redirect_to action: :index
  end

  private

  def comment_params
    params.require(:comment).permit(:open)
  end
  
end
