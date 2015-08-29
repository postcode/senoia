class RepliesController < ApplicationController

  def create
    @comment = Comment.find(params[:comment_id])
    authorize! :manage, @comment.commentable

    @reply = @comment.create_reply(reply_params.merge(user: current_user))
    redirect_to comments_url
  end

  private

  def reply_params
    params.require(:comment).permit(:body)
  end

end

