class Vote < ApplicationRecord
  # belongs_to :user
  belongs_to :story
  validates :story_id, presence: true
end
