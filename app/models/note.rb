class Note < ApplicationRecord
  belongs_to :property
  validates :notes, presence: true, length: { minimum: 1 }

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |note|
        csv << note.attributes.values_at(*column_names)
      end
    end
  end
end
