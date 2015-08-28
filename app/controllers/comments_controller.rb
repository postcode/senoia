class CommentsController < ApplicationController

  def index
    @plans = Plan.joins(:comments).where(comments: { open: true, parent_id: nil }).uniq
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    redirect_to action: :index
  end

  private

  def comment_params
    params.require(:comment).permit(:open)
  end
  
end
