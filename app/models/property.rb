class Property < ApplicationRecord
  validates :situs_address, presence: true, uniqueness: true
  before_validation :uppercase_address
  has_many :notes, dependent: :destroy
  has_many :pins, dependent: :destroy

  geocoded_by :full_address
  after_validation :geocode, if: :should_geocode?

  def full_address
    [situs_address, city, state, zip].compact.join(", ")
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "homestead_indicator", "id", "just_value", "land_acreage", "land_use_code", "land_use_desc", "last_sale_date", "last_sale_price", "last_sale_vori",  "mailing_country", "mailing_postal_code", "mailing_state", "neighborhood_code", "neighborhood_name", "owner_name_line1", "owner_name_line2", "parid", "situs_address" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "situs_address", "owner_name_line1" ]
  end

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

  private

  def should_geocode?
    full_address.present? && (latitude.blank? || longitude.blank?)
  end

end
