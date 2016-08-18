class VotesController < ApplicationController
  # before action authenticate
  # respond js

  def upvote
    @comment = Comment.find_by(id: params[:id])
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])

    if @vote
      @vote.update(value: 1)
      flash[:success] = "Thank you for upvoting!"
      redirect_to topic_post_comments_path(@vote.comment.post.topic, @vote.comment.post)
    end
  end
    # update that vote (+1, -1 in value)
    # create upvote.js.erb and downvote.js.erb which renders the flash message
    # then you have to tie this with a VoteBroadcastJob that connects to an actioncable channel

  def downvote
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])
    @post = Post.includes(:comments).find_by(id: params[:post_id])
    @topic = @post.topic

    if @vote
      @vote.update(value: -1)
      flash[:success] = "You've downvoted!"
      redirect_to topic_post_comment_path(@topic, @post)
    end
  end

  # private
  #   def vote_params
  #     params.require(:vote).permit(:value, :user_id, :comment_id)
  #   end
end
