class Post < ApplicationRecord
  has_many :comments
  belongs_to :topic
  mount_uploader :image, ImageUploader
  belongs_to :user
  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  extend FriendlyId
  friendly_id :title, use: :slugged

  before_save :update_slug

  def update_slug
    if title
      self.slug = title.gsub(" ", "-")
    end
  end
end
