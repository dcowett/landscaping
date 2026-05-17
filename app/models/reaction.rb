# app/models/reaction.rb
class Reaction < ApplicationRecord
  belongs_to :story
  belongs_to :user

  validates :emoji, presence: true
  validates :emoji, uniqueness: { scope: [:story_id, :user_id] }
end
