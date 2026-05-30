class Pin < ApplicationRecord
  belongs_to :user
  belongs_to :property, optional: true
  has_one_attached :image
  #  validates :property, presence: true
  validates :description, presence: true, length: { maximum: 140 }

  scope :without_property, -> { where(property_id: nil) }
  scope :with_property, -> { where.not(property_id: nil) }
end
