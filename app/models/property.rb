class Property < ApplicationRecord
  validates :situs_address, presence: true, uniqueness: true
  before_validation :normalize_address_fields

  has_many :notes, dependent: :destroy
  has_many :pins, dependent: :destroy

  after_commit :geocode_with_geocodio, on: [:create, :update], if: :should_geocode_after_commit?

  def full_address
    [
      situs_address,
      situs_postal_city,
      "FL",
      situs_postal_zip,
      "USA"
    ].compact.join(", ")
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
    self.situs_address = situs_address&.upcase
    self.situs_postal_city = situs_postal_city&.upcase
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

  def normalize_address_fields
    self.situs_address = situs_address.to_s.strip.gsub(/\s+/, " ").presence
    self.situs_postal_city = situs_postal_city.to_s.strip.gsub(/\s+/, " ").presence
    self.situs_postal_zip = situs_postal_zip.to_s.strip.presence
  end

  def should_geocode_after_commit?
    latitude.blank? ||
      longitude.blank? ||
      previous_changes.key?("situs_address") ||
      previous_changes.key?("situs_postal_city") ||
      previous_changes.key?("situs_postal_zip")
  end

  def geocode_with_geocodio
    PropertyGeocodioService.new(self).call
  end

end
