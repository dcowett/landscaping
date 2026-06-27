class Note < ApplicationRecord
  belongs_to :property
  validates :notes, presence: true, length: { minimum: 1 }

  def self.import(file)
    transaction do
      CSV.foreach(file.path, headers: true) do |row|
        create! row.to_hash
      end
    end
  end

  def self.to_csv
    property_map = Property.pluck(:id, :situs_address).to_h
    CSV.generate do |csv|
      csv << %w[ id property_id situs_address updated_at created_at code note ]
      all.each do |note|
        csv << [ note.id, note.property_id, property_map[note.property_id], note.updated_at, note.created_at, note.code, note.notes ]
      end
    end
  end
end
