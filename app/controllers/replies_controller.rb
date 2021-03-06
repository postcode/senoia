class RepliesController < ApplicationController

  def create
    @comment = Comment.find(params[:comment_id])
    authorize! :manage, @comment.commentable
    @reply = @comment.create_reply(reply_params.merge(user: current_user))
    @plan = Plan.find(@comment.commentable_id)
    @reply.send_notifications!

    respond_to do |format|
      format.js
    end
  end

  private

  def reply_params
    params.require(:comment).permit(:body)
  end

end

