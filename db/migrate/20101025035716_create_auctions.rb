class CreateAuctions < ActiveRecord::Migration
  def self.up
    create_table :auctions do |t|
    
      t.date :adate
      t.string :tmk
      t.string :paddress1
      t.string :paddress2
      t.string :paddress3
      t.string :pcity
      t.string :pstate
      t.string :pzip
      t.string :punit
      t.string :aoao
      t.string :fs

      t.string :caddress1
      t.string :caddress2
      t.string :ccity
      t.string :island

      t.string :judicial
      t.datetime :oh1date  # open house date and time
      t.datetime :oh2date
      
      t.string :ts       # internal tracking number for law firm   
      t.string :lfname  # this is the Law Firm's full name
      t.string :lfcontact # this should be the lawyers full name
      t.string :lfphone
      t.string :lfemail
      
      t.string :lender
      t.string :docnumber  # format tells us if it is Regular or Land Court
      
      t.text :adtext

      t.timestamps
    end
  end

  def self.down
    drop_table :auctions
  end
end
