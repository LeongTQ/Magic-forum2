require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before(:all) do
    @user = User.create( {username:"happy", email:"happy@gmail.com", password:"happy"} )
    @unauthorized_user = User.create( {username:"sad", email:"sad@gmail.com", password:"sad"} )
  end

  describe "create user" do
    it "should create new user" do

      params = { user: { username:"angry", email:"angry@gmail.com", password:"angry" } }
      post :create, params: params

      user = User.find_by(email: "happy@gmail.com")

      expect(User.count).to eql(3)
      expect(user.email).to eql("happy@gmail.com")
      expect(user.username).to eql("happy")
      expect(flash[:success]).to eql("Thank you. You're now registered.")
    end
  end

  describe "edit user" do

    it "should redirect if not logged in" do

      params = { id: @user.id }
      get :edit, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { id: @user.id }
      get :edit, params: params, session: { id: @unauthorized_user.id }
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render edit" do

      params = { id: @user.id }
      get :edit, params: params, session: { id: @user.id }

      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end
  end

  describe "update user" do

    it "should redirect if not logged in" do
      params = { id: @user.id, user: { email: "new@email.com", username: "newusername" } }
      patch :update, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { id: @user.id, user: { email: "new@email.com", username: "newusername" } }
      patch :update, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update user" do

      params = { id: @user.id, user: { email: "new@email.com", username: "newusername", password: "newpassword" }}
      patch :update, params: params, session: { id: @user.id }

      @user.reload
      current_user = subject.send(:current_user).reload

      expect(current_user.email).to eql("new@email.com")
      expect(current_user.username).to eql("newusername")
      expect(current_user.authenticate("newpassword")).to eql(@user)
    end
  end
end
