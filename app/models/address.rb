class Address < ApplicationRecord
  validates :street_number, presence: true
  validates :street_name, presence: true

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Address.create! row.to_hash
    end
  end
end
