class Pin < ApplicationRecord
  belongs_to :property
  belongs_to :user
  has_one_attached :image
  validates :property, presence: true
  validates :description, presence: true, length: { maximum: 50 }
end
