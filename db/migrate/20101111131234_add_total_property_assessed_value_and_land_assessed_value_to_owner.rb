class AddTotalPropertyAssessedValueAndLandAssessedValueToOwner < ActiveRecord::Migration
  def self.up
     add_column :owners, :total_property_assessed_value, :string
     add_column :owners, :land_assessed_value, :string
  end

  def self.down
    remove_column :owners, :total_property_assessed_value
    remove_column :owners, :land_assessed_value
  end
end
