class Property < ApplicationRecord
  validates :situs_address, presence: true, uniqueness: true
  validates :last_sale_date, presence: true
  before_validation :uppercase_address
  has_many :notes, dependent: :destroy

  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      Property.create! row.to_hash
    end
  end

  def uppercase_address
    situs_address.upcase!
  end

end
