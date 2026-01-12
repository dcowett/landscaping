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

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Story.create! row.to_hash
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |story|
        csv << story.attributes.values_at(*column_names)
      end
    end
  end

  def to_param
    "#{id}-#{name.gsub(/\W/, '-').downcase}"
  end
end
