require 'rails_helper'

RSpec.describe Topic, type: :model do

  context "assocation" do
    it { should have_many(:posts) }
  end

  context "title validation" do
    it { should validate_length_of(:title) }
    it { should validate_presence_of(:title) }
  end

  context "description validation" do
    it { should validate_length_of(:description) }
    it { should validate_presence_of(:description) }
  end

  context "slug callback" do
    it "should set slug" do
      topic = create(:topic)

      expect(topic.slug).to eql(topic.title.gsub(" ", "-"))
    end

    it "should update slug" do
      topic = create(:topic)

      topic.update(title: "updatedtitle")

      expect(topic.slug).to eql("updatedtitle")
    end
  end
end
  # validates :title, length: { minimum: 5 }, presence: true
  # validates :description, length: { minimum: 20 }, presence: true
