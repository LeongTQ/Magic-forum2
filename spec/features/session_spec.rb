require "rails_helper"

RSpec.feature "Session", type: :feature do

  before(:all) do
    @user = create(:user)
  end

  scenario "User logs in" do

    visit root_path
    click_link('Login')

    within(:css, "#login-form") do
      fill_in 'email_title_field', with: 'user@email.com'
      fill_in 'password_title_field', with: 'password'

    click_button('Login')
    end

    user = User.find_by(email: "user@email.com")

    expect(user.email).to eql("user@email.com")
    expect(find('.flash-messages .message').text).to eql("Welcome back #{user.username}")
    expect(page).to have_current_path(root_path)

  end

  scenario "User logs out" do

    visit root_path
    click_link('Login')

    within(:css, "#login-form") do
      fill_in 'email_title_field', with: 'user@email.com'
      fill_in 'password_title_field', with: 'password'

    end
    click_button('Login')

    click_link("Logout")

    expect(page).to have_current_path(root_path)
    expect(find('.flash-messages .message').text).to eql("You've been logged out")
    expect(find_link('Register')).to be_present
    expect(find_link('Login')).to be_present
  end
end
