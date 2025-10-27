class Property < ApplicationRecord
  validates :situs_address, presence: true, uniqueness: true

  before_validation :uppercase_address
  has_many :notes, dependent: :destroy

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Property.create! row.to_hash
    end
  end

  def uppercase_address
    situs_address.upcase!
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |property|
        csv << property.attributes.values_at(*column_names)
      end
    end
  end
end
