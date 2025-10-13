class Property < ApplicationRecord

  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      Property.create! row.to_hash
    end
  end
end
