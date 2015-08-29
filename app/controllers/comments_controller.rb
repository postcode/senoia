class CommentsController < ApplicationController

  def index
    authorize! :manage, Comment
    @plans_with_outstanding_comments = Plan.with_outstanding_comments.includes(:comment_threads => { :user => [], :children => :user }).page(params[:page]).per(10)
  end

  def update
    authorize! :manage, Comment
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)

    respond_to do |format|
      format.js
    end
  end
  
  def create
    @plan = Plan.find(params[:plan_id])
    authorize! :manage, @plan
    @comment = @plan.comments.create(comment_params.merge(user: current_user, element_id: params[:element_id]))
    @plan.reload
    respond_to do |format|
      format.js
    end
  end

  private

  def comment_params
    case params[:action]
    when "update"
      params.require(:comment).permit(:open)
    when "create"
      params.require(:comment).permit(:body)
    end
  end
  
end
