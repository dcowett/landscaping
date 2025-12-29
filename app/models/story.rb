class Story < ApplicationRecord
  acts_as_taggable
  belongs_to :user
  validates :name, :link, presence: true
  validates :link, url: true
  has_many :votes, dependent: :destroy do
    def latest
      order("id DESC").limit(5)
    end
  end

  has_many :likes, as: :reference, dependent: :destroy  do
    def liked?(user)
      !!self.likes.find{ | like | like.user_id == user_id }
    end
  end

  def to_param
    "#{id}-#{name.gsub(/\W/, '-').downcase}"
  end
end
