class Note < ApplicationRecord
  belongs_to :property
  validates :notes, presence: true, length: { minimum: 1 }

  def self.to_csv
    CSV.generate do |csv|
      column_names = %w( PropertyID Address Updated Created Code Note )
          csv << column_names
          all.each do |note|
            @property = Property.find(note.property_id)
            @address = @property.situs_address
            csv << [ note.property_id, @address, note.updated_at, note.created_at, note.code, note.notes  ]
      end
    end
  end
end
