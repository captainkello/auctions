class CreateRejects < ActiveRecord::Migration
  def self.up
    create_table :rejects do |t|
      t.text :adtext
      t.integer :doc_number

      t.timestamps
    end
  end

  def self.down
    drop_table :rejects
  end
end
