class RepliesController < ApplicationController

  def create
    @comment = Comment.find(params[:comment_id])
    @reply = Comment.create(reply_params.merge(commentable: @comment.commentable, user: current_user))
    @reply.move_to_child_of(@comment)
    redirect_to comments_url
  end

  private

  def reply_params
    params.require(:comment).permit(:body)
  end

end

