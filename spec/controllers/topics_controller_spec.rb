require 'rails_helper'

RSpec.describe TopicsController, type: :controller do

  before(:all) do
    @admin = create(:user, :admin)
    @user = create(:user, :sequenced_username, :sequenced_email )
    @topic = create(:topic, :sequenced_title, :sequenced_description)
   end

   describe "index topics" do
     it "should render index" do

       get :index
       expect(Topic.count).to eql(1)
       expect(subject).to render_template(:index)
     end
   end

   describe "new topic" do
    it "should deny if not logged in" do

      get :new
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should render new for admin" do

      get :new, session: { id: @admin.id }

      expect(subject).to render_template(:new)
      expect(subject).to be_present
     end

     it "should deny user" do

       get :new, session: { id: @user.id }
       expect(flash[:danger]).to eql("You're not authorized")
     end
   end

  describe "create topic" do
    it "should deny if not logged in" do

      params = { topic: { title: "Topic2", description: "This is the best topic ever" } }
      post :create, params: params
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should create new topic for admin" do

      params = { topic: { title: "Topic2", description: "This is the best topic ever", user_id: @admin.id } }
      post :create, params: params, session: { id: @admin.id }

      topic = Topic.find_by(title: "Topic2")

      expect(Topic.count).to eql(2)
      expect(topic.description).to eql("This is the best topic ever")
      expect(subject).to redirect_to(topics_path)
      expect(flash[:success]).to eql("You've created a new topic.")
    end

    it "should deny user" do

      params = { topic: { title: "Topic2", description: "This is the best topic ever", user_id: @admin.id } }
      post :create, params: params, session: { id: @user.id }
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end
  end

  describe "edit topic" do
    it "should render edit for admin" do

      params = { id: @topic.id }
      get :edit, params: params, session: { id: @admin.id }

      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(subject).to be_present
    end

    it "should deny if not logged in" do

      params = { id: @topic.id }
      get :edit, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should deny if not admin" do

      params = { id: @topic.id }
      get :edit, params: params, session: { id: @user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end
  end

  describe "update topic" do

    it "should update if user is admin" do

      params = { id: @topic.id, topic: { title: "Topic3", description: "We must always update at all times" } }
      patch :update, params: params, session: { id: @admin.id }

      @topic.reload
      expect(@topic.title).to eql("Topic3")
      expect(@topic.description).to eql("We must always update at all times")
      expect(flash[:success]).to eql("You've updated the topic.")
      expect(subject).to redirect_to(topics_path)
    end

    it "should deny if not logged in" do

      params = { id: @topic.id }
      patch :update, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")

    end

    it "should deny if not admin" do

      params = { id: @topic.id }
      patch :update, params: params, session: { id: @user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end
  end

  describe "destroy topic" do

    it "should destroy if admin" do

      params = { id: @topic.id }
      delete :destroy, params: params, session: { id: @admin.id }

      expect(Topic.count).to eql(0)
      expect(subject).to redirect_to(topics_path)
      expect(flash[:success]).to eql("You've deleted the topic.")
    end

    it "should deny if not logged in" do

      params = { id: @topic.id }
      delete :destroy, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")

    end

    it "should deny if not admin" do

      params = { id: @topic.id }
      delete :destroy, params: params, session: { id: @user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end
  end
end
