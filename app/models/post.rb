class Post < ApplicationRecord
  has_many :comments
  belongs_to :topic
  mount_uploader :image, ImageUploader
  belongs_to :user
  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
end
