class CommentsController < ApplicationController

  def show
    @comment = Comment.find(params[:id])
    authorize! :read, @comment
    redirect_to [ @comment.commentable, anchor: "comment-#{@comment.id}" ]
  end

  def index
    authorize! :manage, Comment
    @plans_with_outstanding_comments = Plan
      .with_outstanding_comments
      .order("updated_at DESC")
      .includes(:comment_threads => { :user => [], :children => :user })
      .page(params[:page]).per(10)
  end

  def update
    authorize! :edit, Comment
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    if @comment.open == false
      @comment.children.each do |child|
        child.open = false
        child.save!
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def create
    @plan = Plan.find(params[:plan_id])
    authorize! :create, Comment
    @comment = @plan.comments.create(comment_params.merge(user: current_user, element_id: params[:element_id]))
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
