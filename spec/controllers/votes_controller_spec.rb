require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  before(:all) do
    @user = User.create( { username:"user", email:"user@gmail.com", password:"user" } )
    @admin = User.create( { username:"admin", email:"admin@gmail.com", password:"admin", role: "admin"})
    @topic = Topic.create( { title: "Topic1", description: "Just keep testing and testing", user_id: @admin.id } )
    @post = Post.create( { title: "Post1", body: "Post Post Post Post Post Post", user_id: @user.id, topic_id: @topic.id } )
    @comment = Comment.create( { body: "commenting is the way of life", user_id: @user.id, post_id: @post.id})
  end

  describe "upvote comment" do

      it "should require login" do

        params = { id: @comment.id }
        post :upvote, params: params

        expect(subject).to redirect_to(root_path)
        expect(flash[:danger]).to eql("You need to login first")
      end

      it "should create vote if non-existant" do

        params = { comment_id: @comment.id }
        expect(Vote.count).to eql(0)

        post :upvote, params: params, session: { id: @user.id }

        expect(Vote.count).to eql(1)
        expect(Vote.first.user).to eql(@user)
        expect(Vote.first.comment).to eql(@comment)
      end

      it "should find vote if existant" do

        @vote = @user.votes.create(comment_id: @comment.id)
        expect(Vote.count).to eql(1)

        params = { comment_id: @comment.id }
        post :upvote, params: params, session: { id: @user.id }

        expect(Vote.count).to eql(1)
        expect(assigns[:vote]).to eql(@vote) #this means that we are checking if the blue vote(vote controller) is the same as the @vote(created in this test)
      end

      it "should +1 vote" do

        params = { comment_id: @comment.id }
        post :upvote, params: params, session: { id: @user.id }

        expect(assigns[:vote].value).to eql(1)
        expect(Vote.first.value).to eql(1)
      end
    end

    describe "downvote comment" do
      it "should require login" do

        params = { id: @comment.id }
        post :downvote, params: params

        expect(subject).to redirect_to(root_path)
        expect(flash[:danger]).to eql("You need to login first")
      end

      it "should create vote if non-existant" do

        params = { comment_id: @comment.id }
        expect(Vote.count).to eql(0)

        post :downvote, params: params, session: { id: @user.id }

        expect(Vote.count).to eql(1)
        expect(Vote.first.user).to eql(@user)
        expect(Vote.first.comment).to eql(@comment)
      end

      it "should find vote if existant" do

        @vote = @user.votes.create(comment_id: @comment.id)
        expect(Vote.count).to eql(1)

        params = { comment_id: @comment.id }
        post :downvote, params: params, session: { id: @user.id }

        expect(Vote.count).to eql(1)
        expect(assigns[:vote]).to eql(@vote) 
      end

      it "should -1 vote" do

        params = { comment_id: @comment.id }
        post :downvote, params: params, session: { id: @user.id }

        expect(assigns[:vote].value).to eql(-1)
        expect(Vote.first.value).to eql(-1)
      end
    end
  end
