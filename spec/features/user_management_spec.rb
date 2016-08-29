require "rails_helper"

RSpec.feature "User Management", type: :feature do

  before(:all) do
    @user = create(:user)
  end

  scenario "User registers" do

    visit root_path
    click_link('Register')

    within(:css, "#register-form") do
      fill_in 'username_title_field', with: 'ironman'
      fill_in 'email_title_field', with: 'ironman@email.com'
      fill_in 'password_title_field', with: 'password'
      fill_in 'password_title_confirm_field', with: 'password'
      # fill_in 'post_image_field', with: 'image'
    click_button('Register')
    end

    user = User.find_by(email: "ironman@email.com")

    expect(User.count).to eql(2)
    expect(user).to be_present
    expect(user.email).to eql("ironman@email.com")
    expect(user.username).to eql("ironman")
    expect(find('.flash-messages .message').text).to eql("Thank you. You're now registered.")
    expect(page).to have_current_path(root_path)
  end

  scenario "username registration error" do

    visit root_path
    click_link('Register')

    within(:css, "#register-form") do
      fill_in 'username_title_field', with: 'bob'
      fill_in 'email_title_field', with: 'ironman@email.com'
      fill_in 'password_title_field', with: 'password'
      fill_in 'password_title_confirm_field', with: 'password'

    click_button('Register')
    end

    expect(User.count).to eql(1)
    expect(find('.flash-messages .message').text).to eql("Username has already been taken")
    expect(page).to have_current_path(root_path)
  end

  scenario "email registration error" do
    visit root_path
    click_link('Register')

    within(:css, "#register-form") do
      fill_in 'username_title_field', with: 'ironman'
      fill_in 'email_title_field', with: 'user@email.com'
      fill_in 'password_title_field', with: 'password'
      fill_in 'password_title_confirm_field', with: 'password'

    click_button('Register')
    end

    expect(User.count).to eql(1)
    expect(find('.flash-messages .message').text).to eql("Email has already been taken")
  end

  scenario "user redirected if not logged in" do

    visit edit_user_path(@user)

    expect(find('.flash-messages .message').text).to eql("You need to login first")
  end

  scenario "user updates password" do

    visit root_path
    click_link('Login')
    click_link('Reset Password')

    within(:css, "#user-reset-password-form") do
      fill_in 'user_email_field', with: 'user@email.com'

    click_button('Reset my password!')
    end

    user = User.find_by(email: "user@email.com")

    expect(page).to have_current_path(root_path)
    expect(find('.flash-messages.message').text).to eql("We've sent you instructions on how to reset your password")
  end
end
