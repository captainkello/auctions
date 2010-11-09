class CreateOwners < ActiveRecord::Migration
  def self.up
    create_table :owners do |t|
      t.string :tmk
      t.string :owner_name
      t.text :site_address
      t.string :apartment_no
      t.string :property_class
      t.string :total_parcel_area
      t.string :zoning

      t.timestamps
    end
  end

  def self.down
    drop_table :owners
  end
end
