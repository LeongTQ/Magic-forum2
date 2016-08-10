class Post < ApplicationRecord
  has_many :comments
  belongs_to :topic
  mount_uploader :image, ImageUploader
  belongs_to :user
end
