class Note < ApplicationRecord
  belongs_to :property
  validates :notes, presence: true, length: { minimum: 1 }

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Note.create! row.to_hash
    end
  end

  def self.to_csv
    propertyArray = Property.pluck(:id, :situs_address)
    CSV.generate do |csv|
      column_names = %w[ id property_id situs_address updated_at created_at code note ]
          csv << column_names
          all.each do |note|
            @address = propertyArray.find { |id| id[0] == note.property_id }
            csv << [ note.id, note.property_id, @address[1], note.updated_at, note.created_at, note.code, note.notes  ]
      end
    end
  end
end
