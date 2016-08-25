require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  before(:all) do
    @admin = create(:user, :admin)
    @user = create(:user, :sequenced_username, :sequenced_email)
    @unauthorized_user = create(:user, :sequenced_username, :sequenced_email)
    @topic = create(:topic, :sequenced_title, :sequenced_description)
    @post = create(:post, :sequenced_title, :sequenced_body, user_id: @user.id, topic_id: @topic.id)
    @comment = create(:comment, :sequenced_body, user_id: @user.id, post_id: @post.id)
  end

  describe "index comments" do
    it "should render index" do

      params = { topic_id: @topic.id, post_id: @post.id }
      get :index, params: params

      expect(assigns[:comments].count).to eql(1)
      expect(subject).to render_template(:index)
    end
  end

  describe "create comment" do
    it "should deny if user not logged in" do

      params = { topic_id: @topic.id, post_id: @post.id, comment: { body: "commenting is the way of life", image: "newimage"  } }
      post :create, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end
  end

    it "should create new comment" do

      params = { topic_id: @topic.id, post_id: @post.id, comment: { body: "commenting is the way of life"  } }
      post :create, xhr: true, params: params, session: { id: @user.id }

      comment = Comment.find_by(body: "commenting is the way of life")

      expect(Comment.count).to eql(2)
      expect(comment.body).to eql("commenting is the way of life")
      expect(flash[:success]).to eql("You've created a new comment.")
    end

  describe "edit comment" do
    it "should render edit for user" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      get :edit, xhr: true, params: params, session: { id: @user.id }

      current_user = subject.send(:current_user)
      expect(current_user).to eql(@user)
      expect(subject).to render_template(:edit)
    end

    it "should deny if not logged in" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      get :edit, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should deny if unauthorized" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      get :edit, xhr: true, params: params, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end
  end

  describe "update comment" do
    it "should deny if user not logged in" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment: { body: "comment3 comment3 comment3"  } }
      patch :update, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should deny unauthorized user" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment: { body: "comment3 comment3 comment3"  } }
      patch :update, xhr: true, params: params, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end
  end

  describe "destroy comment" do

    it "should deny if not logged in" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      delete :destroy, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")

    end

    it "should deny if unauthorized" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      delete :destroy, xhr: true, params: params, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should destroy if user" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      delete :destroy, xhr: true, params: params, session: { id: @user.id }

      expect(Comment.count).to eql(0)
      expect(flash[:success]).to eql("You've deleted the comment.")
    end

    it "should destroy if user is admin" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      delete :destroy, xhr: true, params: params, session: { id: @admin.id }

      expect(Comment.count).to eql(0)
      expect(flash[:success]).to eql("You've deleted the comment.")
    end
  end
end
