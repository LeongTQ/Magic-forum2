require 'rails_helper'

RSpec.feature "User Navigation", type: :feature do
  before(:all) do
    @user = create(:user)
    @topic = create(:topic)
  end

  scenario "User visits topics" do

    visit root_path
    click_link('Topics')

    expect(page).to have_current_path(topics_path)
  end
end
