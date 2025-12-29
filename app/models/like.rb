class Like < ApplicationRecord
  # belongs_to :user
  # belongs_to :story, counter_cache: true
  # validates :user_id, uniqueness: { scope: :story_id }
  belongs_to :user
  belongs_to :reference, polymorphic: true, counter_cache: true
  validates_presence_of :value, :user, :reference
  validates :user_id, uniqueness: { scope: [:reference_id, :reference_type] }
  validates :value, inclusion: 0..4
end
