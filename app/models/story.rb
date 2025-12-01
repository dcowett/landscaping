class Story < ApplicationRecord
  belongs_to :user
  validates :name, :link, presence: true
  validates :link, url: true
  has_many :votes, dependent: :destroy do
    def latest
      order('id DESC').limit(5)
    end
  end

  def to_param
    "#{id}-#{name.gsub(/\W/, '-').downcase}"
  end
end
