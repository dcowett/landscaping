class Vote < ApplicationRecord
  belongs_to :story, counter_cache: true
  belongs_to :user
  validates :story_id, presence: true
  validates :user_id, uniqueness: { scope: :story_id }
end
