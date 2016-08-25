class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  has_secure_password
  has_many :topics
  has_many :posts
  has_many :comments
  validates :email, uniqueness: true, presence: true
  validates :username, uniqueness: true, presence: true
  enum role: [:user, :moderator, :admin]
  has_many :votes

  extend FriendlyId
  friendly_id :username, use: :slugged

  before_save :update_slug

  def update_slug
    if username
      self.slug = username.gsub(" ", "-")
    end
  end
end
