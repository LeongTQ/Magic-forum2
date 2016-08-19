class CommentsController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @post = Post.includes(:comments).find_by(slug: params[:post_id])
    @topic = @post.topic
    @comments = @post.comments.order("created_at DESC").page(params[:page]).per(5)
    @comment = Comment.new
  end

  def create
    @post = Post.find_by(slug: params[:post_id])

    @topic = @post.topic
    @comment = current_user.comments.build(comment_params.merge(post_id: @post.id))
    @new_comment = Comment.new

    if @comment.save
      CommentBroadcastJob.perform_later("create", @comment)
      flash.now[:success] = "You've created a new comment."
    else
      flash.now[:danger] = @comment.errors.full_messages
    end
  end

  def edit
   @post = Post.find_by(slug: params[:post_id])
   @topic = @post.topic
   @comment = Comment.find_by(id: params[:id])
   authorize @comment
 end

  def update
    @post = Post.find_by(slug: params[:post_id])
    @topic = @post.topic
    @comment = Comment.find_by(id: params[:id])
    @comment_updated = false
    authorize @comment

    if @comment.update(comment_params)
      @comment_updated = true
      CommentBroadcastJob.perform_now("update", @comment)
      flash.now[:success] = "You've updated your comment."

    else
      flash.now[:danger] = @comment.errors.full_messages

    end

  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @topic = @comment.post.topic
    authorize @comment

    if @comment.destroy
      CommentBroadcastJob.perform_now("destroy", @comment)
      flash.now[:success] = "You've deleted the comment."
    end

  end

  private

  def comment_params
    params.require(:comment).permit(:body, :image)
  end

end
