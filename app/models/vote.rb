class Vote < ApplicationRecord
  belongs_to :story
  belongs_to :user
  validates :story_id, presence: true
end
