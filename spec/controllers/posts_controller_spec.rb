require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  before(:all) do
    @admin = create(:user, :admin)
    @user = create(:user, :sequenced_username, :sequenced_email)
    @unauthorized_user = create(:user, :sequenced_username, :sequenced_email)
    @topic = create(:topic, :sequenced_title, :sequenced_description)
    @post = create(:post, :sequenced_title, :sequenced_body, user_id: @user.id, topic_id: @topic.id)

   end

   describe "index posts" do
    it "should render index" do

      params = { topic_id: @topic.id }
      get :index, params: params

      expect(assigns[:posts].count).to eql(1)
      expect(subject).to render_template(:index)
    end
  end

    describe "create post" do
      it "should deny if user not logged in" do

        params = { topic_id: @topic.id }
        post :create, params: params
        expect(flash[:danger]).to eql("You need to login first")
      end

      it "should create new post" do

        params = { topic_id: @topic.id, post: { title: "Post2", body: "Post me Post me Post me" }}

        post :create, xhr: true, params: params, session: { id: @user.id }
        post = Post.find_by(title: "Post2")
        expect(Post.count).to eql(2)
        expect(post.title).to eql("Post2")
        expect(post.body).to eql("Post me Post me Post me")
        expect(flash[:success]).to eql("You've created a new post.")
      end
    end

    describe "edit post" do
      it "should render edit for user" do

        params = { topic_id: @topic.id, id: @post.id }
        get :edit, params: params, session: { id: @user.id }

        current_user = subject.send(:current_user)
        expect(subject).to render_template(:edit)
        expect(subject).to be_present
      end

      it "should deny if not logged in" do

        params = { topic_id: @topic.id, id: @post.id }
        get :edit, params: params

        expect(subject).to redirect_to(root_path)
        expect(flash[:danger]).to eql("You need to login first")
      end

      it "should deny if unauthorized" do

        params = { topic_id: @topic.id, id: @post.id }
        get :edit, params: params, session: { id: @unauthorized_user.id }

        expect(subject).to redirect_to(root_path)
        expect(flash[:danger]).to eql("You're not authorized")
      end
    end

    describe "update post" do

      it "should deny if user not logged in" do

        params = { topic_id: @topic.id, id: @post.id }
        patch :update, params: params

        expect(subject).to redirect_to(root_path)
        expect(flash[:danger]).to eql("You need to login first")
      end

      it "should deny if unauthorized user" do

        params = { topic_id: @topic.id, id: @post.id }
        patch :update, params: params, session: { id: @unauthorized_user.id }

        expect(subject).to redirect_to(root_path)
        expect(flash[:danger]).to eql("You're not authorized")
      end

      it "should update post" do

        params = { topic_id: @topic.id, id: @post.id, post: { title: "Post3", body: "POST HELP POST HELP POST" }}
        patch :update, params: params, session: { id: @user.id }
        @post.reload
        expect(@post.title).to eql("Post3")
        expect(@post.body).to eql("POST HELP POST HELP POST")
        expect(flash[:success]).to eql("You've updated the post.")
        expect(subject).to redirect_to(topic_posts_path(@topic))
      end
    end

    describe "destroy post" do

      it "should deny if not logged in" do

        params = { topic_id: @topic.id, id: @post.id }
        delete :destroy, params: params

        expect(subject).to redirect_to(root_path)
        expect(flash[:danger]).to eql("You need to login first")

      end

      it "should deny if unauthorized" do

        params = { topic_id: @topic.id, id: @post.id }
        delete :destroy, params: params, session: { id: @unauthorized_user.id }

        expect(subject).to redirect_to(root_path)
        expect(flash[:danger]).to eql("You're not authorized")
      end

      it "should destroy if user" do

        params = { topic_id: @topic.id, id: @post.id }
        delete :destroy, params: params, session: { id: @user.id }

        expect(Post.count).to eql(0)
        expect(subject).to redirect_to(topic_posts_path(@topic))
        expect(flash[:success]).to eql("You've deleted the post.")
      end

      it "should destroy if user is admin" do

        params = { topic_id: @topic.id, id: @post.id }
        delete :destroy, params: params, session: { id: @admin.id }

        expect(Post.count).to eql(0)
        expect(subject).to redirect_to(topic_posts_path(@topic))
        expect(flash[:success]).to eql("You've deleted the post.")
      end
    end
end
