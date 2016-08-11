class Comment < ApplicationRecord
  belongs_to :post
  mount_uploader :image, ImageUploader
  belongs_to :user
  validates :body, length: { minimum: 20 }, presence: true
end
