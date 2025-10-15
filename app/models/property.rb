class Property < ApplicationRecord
  validates :situs_address, :last_sale_date, presence: true

  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      Property.create! row.to_hash
    end
  end
end
