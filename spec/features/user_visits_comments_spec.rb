require 'rails_helper'

RSpec.feature "User Visits Comments", type: :feature, js: true do
  before(:all) do
    @user = create(:user)
    @topic = create(:topic)
  end

  scenario "User adds, edits, upvotes, downvotes and delete comment" do

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

    click_button('close')

  end
end
    # click_button('close.flash-messages')
    #
    # click_link("Topics")
    # click_link("Ruby Week 3")
    # click_link("12345")
    #
    # fill_in "Body", with: "This is a new comment and this feels amazing"
    # click_button("Create Comment")
    # expect(page).to have_content("This is a new comment and this feels amazing")
