require 'mechanize'
class ReweItem
  
  def self.parse_bryson_format(link_data,doc_no)
    data = link_data.split(' ')
        
    insert_hash = {}
    #get association of apartment owners
    if link_data.include? 'Association of Apartment Owners of'
      aoaoindex = data.index('Owners')
      aoao = data[ (aoaoindex + 2)..(aoaoindex + 6)].join(' ').chop
      puts "Association of apartment owners -- #{aoao}"
      insert_hash.merge!({:aoao => aoao})
    end
         
    if link_data.include? 'sale by public auction on'
      auction_index = data.index('auction')
      auction_date= data[ (auction_index + 2)..(auction_index + 4) ].join(' ')
      puts "Auction date -- #{auction_date}"
      insert_hash.merge!({:adate => auction_date })
      court_address1 = data[ (auction_index + 10)..(auction_index + 13)].join(' ')
      court_address2 = data[ (auction_index + 14)..(auction_index + 16)].join(' ')
      court_address3 = data[ auction_index + 18 ].chomp
      #puts "Court address -- #{court_address}"
      insert_hash.merge!({:caddress1 => court_address1, :caddress2 => court_address2,:ccity => court_address3})
            
    end
        
    if link_data.include? 'real property located at'
      property_location_index = data.index 'located'
      property_address = data[ (property_location_index + 2)..(property_location_index + 7)].join(' ')
      paddress1 = data[ (property_location_index + 2)]
      paddress2 = data[ (property_location_index + 3)]
      paddress3 = data[ (property_location_index + 4)]
      pcity = data[ (property_location_index + 5)]
      pstate = data[ (property_location_index + 6)]
      pzip = data[ (property_location_index + 7)]
          
      puts "Property address -- #{property_address}"
      insert_hash.merge!({:paddress1 => paddress1, :paddress2 => paddress2,:paddress3 => paddress3, :pcity => pcity, :pstate => pstate, :pzip => pzip})
    end
       
    if link_data.include? 'Unit No.'
      unit_index = data.index 'Unit'
      unit_number = data[(unit_index + 2)..(unit_index + 7)].join(' ')
      puts  "Unit number -- #{unit_number}"
      insert_hash.merge!({:punit => unit_number})
    end
      
    if link_data.include? '(TMK'
      tmk_index = data.index '(TMK'
      tmk_number = data[(tmk_index + 2)..(tmk_index + 6)].join(' ')
      puts "TMK No -- #{tmk_number}"
      insert_hash.merge!({:tmk => tmk_number})
    end
      
    insert_hash.merge!({:adtext => link_data,:lfname => 'Bryson', :docnumber => doc_no })
    Auction.create(insert_hash)
    ReweItem.get_address_from_tmk(tmk_number) unless tmk_number.nil?
  end

  def self.parse_derek_format(link_data,doc_no)

    data = link_data.split(' ')
    insert_hash = {}
        
    #get TS No
    if link_data.include? 'TS No:'
      ts_no = data[ data.index('TS') + 2 ]
      puts "TS NO -- #{ts_no}"
      insert_hash.merge!({:ts => ts_no})
    end
         
    #get TMK No
    if link_data.include? 'TMK No:'
      tmk_no = data[ data.index('TMK') + 2 ] + ' ' + data[ data.index('TMK') + 3 ]
      puts "TMK NO -- #{tmk_no}"
      insert_hash.merge!({:tmk => tmk_no})
    end
         
    #get Property address
    if link_data.include? 'Property Address:'
      addressIndex = data.index('Address:') + 1
      property_address = data[ addressIndex.. addressIndex+6].join(' ').chop
      paddress1 = data[addressIndex + 1]
      paddress2 = data[(addressIndex + 2)..(addressIndex + 3)].join(' ')
      paddress3 = data[addressIndex + 4]
      pcity = data[addressIndex + 5]
      pstate = data[addressIndex + 6]
      pzip = data[addressIndex + 7]
      puts "Property Address -- #{property_address}"
      insert_hash.merge!({:paddress1 => paddress1, :paddress2 => paddress2,:paddress3 => paddress3, :pcity => pcity, :pstate => pstate, :pzip => pzip})
    end
        
    #get system document number
    if link_data.include? 'System document number'
      system_doc_no = data[ data.index('number') + 1 ]
      puts "System Document No -- #{system_doc_no}"
    end
        
    # get auction date
    if link_data.include? 'auction of the real property'
      auctionDate = data.index('auction')
      month = data[ (auctionDate + 10)..(auctionDate + 12)].join(' ')
      day = data[ auctionDate + 11 ].chop!
      year = data[ auctionDate + 12 ]
      puts "Auction Date -- #{month} #{day} #{year}"
      insert_hash.merge!({:adate => month })
    end
        
    #get court location
    if link_data.include? 'First Circuit Court'
      court_address_index = data.index 'Circuit'
      court_address1 = data[ (court_address_index + 2)]
      court_address2 = data[ (court_address_index + 3)]
      court_address3 = data[ (court_address_index + 4)]
      #puts "Court Address -- #{court_address}"
      insert_hash.merge!({:caddress1 => court_address1, :caddress2 => court_address2,:ccity => court_address3})
    end
        
    insert_hash.merge!({:adtext => link_data,:lfname => 'Derek Wong', :docnumber => doc_no })
    Auction.create(insert_hash)
    ReweItem.get_address_from_tmk(tmk_no) unless tmk_no.nil?
  end



  def self.parse_david_format(link_data,doc_no)
    data = link_data.split(' ')
    insert_hash = {}
       
    attorney_index = data.index 'David'
    attorney_email = data[ attorney_index + 7 ]
    attorney_address = data[ (attorney_index + 8)..(attorney_index + 15) ].join(' ')
    puts "Attorney -- David B. Rosen"
    puts "Attorney Email -- #{attorney_email}"
    puts "Attorney Address -- #{attorney_address}"
    insert_hash.merge!({ :lfcontact => attorney_address,:lfemail => attorney_email})
       
    if link_data.include? 'Mortgagor/Borrower:'
      mortgator_index = data.index 'Mortgagor/Borrower:'
      mortgator = data[ mortgator_index + 1]+' '+data[mortgator_index + 2 ]
      puts "Mortgator -- #{mortgator}"
    end
        
    if link_data.include? 'Document No'
      document_index = data.index 'No'
      document_number = data[ document_index + 1 ]
      puts "Document No -- #{document_number}"
    end
       
    if link_data.include? 'public auction on'
      auctionDate = data.index('auction')
      month = data[ auctionDate + 2 ]
      day = data[ auctionDate + 3 ].chop!
      year = data[ auctionDate + 4 ]
      puts "Auction Date -- #{month} #{day} #{year}"
      auction_date = month+' '+day+' '+year
      insert_hash.merge!({:adate => auction_date })
    end
        
    if link_data.include? 'first circuit court Building'
      court_address_index = data.index 'Building'
      court_address1 = data[ (court_address_index + 2)]
      court_address2 = data[ (court_address_index + 3)]
      court_address3 = data[ (court_address_index + 4)]
      # puts "Court Address -- #{court_address}"
      insert_hash.merge!({:caddress1 => court_address1, :caddress2 => court_address2,:ccity => court_address3})
    end
        
    if link_data.include? 'real property located at'
      property_address_index = data.index 'located'
      property_address = data[(property_address_index + 2)..(property_address_index+8)].join(' ').chop
      puts "property address -- #{property_address}"
      paddress1 = data[property_address_index + 2]
      paddress2 = data[(property_address_index + 3)..(property_address_index + 4)].join(' ')
      paddress3 = data[property_address_index + 5]
      pcity = data[property_address_index + 6]
      pstate = data[property_address_index + 7]
      pzip = data[property_address_index + 8]
      insert_hash.merge!({:paddress1 => paddress1, :paddress2 => paddress2,:paddress3 => paddress3, :pcity => pcity, :pstate => pstate, :pzip => pzip})
    end
        
    if link_data.include? 'Fee Simple'
      fee_index = data.index 'Fee'
      fee_simple = data[ fee_index  ]+' '+data[ fee_index + 1 ]
      puts "fee simple #{fee_simple}"
      insert_hash.merge!({:fs => "Fee Simple"})
    end
    if link_data.include? 'Tax Map Key Number'
      tmk_index = data.index 'Map'
      tmk_no = data[(tmk_index+ 4)..(tmk_index+ 4)].join(' ')
      puts "tmk no -- #{tmk_no}"
      insert_hash.merge!({:tmk => tmk_no})
    end
        
        
    insert_hash.merge!({:adtext => link_data,:lfname => 'David B. Rosen', :docnumber => doc_no })
    Auction.create(insert_hash)
    ReweItem.get_address_from_tmk(tmk_no) unless tmk_no.nil?
  end

  def self.parse_michael_format(link_data,doc_no)
    data = link_data.split(' ')
    insert_hash = {}
      
    #get Michael's address
    address_index = data.index 'Michael'
    lfcontact = data[(address_index+ 4)..(address_index+15)].join(' ')
    lfphone = data[ addressindex + 16 ]
    insert_hash.merge!({:lfcontact => lfcontact,:lfphone => lfphone })
      
    #get fs
    if link_data.include? 'FEE SIMPLE FORECLOSURE'
      fFS = data.index('FEE')
      puts data[ fFS ]
      puts data[ fFS + 1 ]
      insert_hash.merge!({:fs => "FEE SIMPLE"})
      fProperty = data.index('FORECLOSURE')
      puts data[ fProperty + 2 ]
      puts data[ fProperty + 3 ]
      puts data[ fProperty + 4 ].chop!
      puts data[ fProperty + 5 ]
      puts data[ fProperty + 7 ].chop!
      puts data[ fProperty + 8 ]
      puts data[ fProperty + 9 ]
      puts data[ fProperty + 10 ]
      puts data[ fProperty + 11 ]
      puts data[ fProperty + 12 ]
      puts data[ fProperty + 13 ]
      puts data[ fProperty + 14 ]
      puts data[ fProperty + 15 ]
      puts data[ fProperty + 16 ]
      puts data[ fProperty + 17 ]
      puts data[ fProperty + 18 ]
      puts data[ fProperty + 19 ]
      puts data[ fProperty + 20 ]
      puts data[ fProperty + 21 ]
      puts data[ fProperty + 22 ]
      puts data[ fProperty + 23 ].chop!
      paddress1 =  data[ fProperty + 24 ]
      paddress2 =  data[ (fProperty + 25)..(fProperty + 26) ].join(' ')
      paddress3 =  data[ (fProperty + 27)..(fProperty + 28) ].join(' ')
      puts data[ fProperty + 26 ].chop!
      puts data[ fProperty + 27 ]
      puts data[ fProperty + 28 ].chop!
      pcity =  data[ fProperty + 29 ]
      pstate =  data[ fProperty + 30 ]
      pzip =  data[ fProperty + 31 ].chop!
      insert_hash.merge!({:paddress1 => paddress1, :paddress2 => paddress2,:paddress3 => paddress3, :pcity => pcity, :pstate => pstate, :pzip => pzip})
    end
      
    if link_data.include? 'TMK'
      tmk = data[ data.index('TMK') + 1]
      puts tmk
      insert_hash.merge!({:tmk => tmk})
    end
       
    #get  auction date
    if link_data.include? 'AUCTION DATE'
      auction_index = data.index('auction')
      auction_date= data[ (auction_index + 2)..(auction_index + 4) ].join(' ')
      puts auction_date
      insert_hash.merge!({:adate => auction_date })
      court_address_index = data.index 'Court'
      court_address1 = data[(court_address+1)]
      court_address2 = data[(court_address+2)]
      court_address3 = data[(court_address+3)]
      #puts court_address
      insert_hash.merge!({:caddress1 => court_address1, :caddress2 => court_address2,:ccity => court_address3})
    end
      
    if link_data.include?'real property located'
      property_index = data.index 'located'
      property_address = data[(property_index + 2)..(property_index + 8)].join(' ')
      paddress1 = data[(property_index + 2)]
      paddress2 = data[(property_index + 3)..(property_index + 4)]
      paddress3 = data[(property_index + 5)]
      pcity = data[(property_index + 6)]
      pstate = data[(property_index + 7)]
      pzip = data[(property_index + 8)]
          
      puts property_address
      insert_hash.merge!({:paddress1 => paddress1, :paddress2 => paddress2,:paddress3 => paddress3, :pcity => pcity, :pstate => pstate, :pzip => pzip})
    end
      
    insert_hash.merge!({:adtext => link_data,:lfname => 'Michael R. Daniels', :docnumber => doc_no })
    Auction.create(insert_hash)
    ReweItem.get_address_from_tmk(tmk) unless tmk.nil?
  end

  def self.parse_johnson_format(link_data,doc_no)
    data = link_data.split(' ')
    insert_hash = {}
         
    puts "Johnson S. Chen"
    #get address
    if link_data.include? 'NOTICE OF FORECLOSURE'
      address_index = data.index 'FORECLOSURE'
      address = data[(address_index + 1)..(address_index+6)].join(' ')
      puts "address -- #{address}"
    end
        
    #get civil no
    if link_data.include? 'Civil No.'
      civil_data = data[data.index('Civil') + 2]
      puts "civil #{civil_data}"
    end
      
    #get tmk
    if link_data.include? 'TMK:'
      tmk_no = data[data.index('TMK:')+1]
      puts "tmk no -- #{tmk_no}"
      insert_hash.merge!({:tmk => tmk_no})
    end
      
    #get association of apartment owners
    if link_data.include? 'Association of Apartment Owners of'
      aoao_index = data.index 'Owners'
      aoao = data[(aoao_index + 2)..(data.index('vs.')+1)].join(' ')
      puts "aoao -- #{aoao}"
      insert_hash.merge!({:aoao => aoao})
    end

    #get auction date
    if link_data.include? 'sale by public auction on'
      auction_index = data.index('auction')
      auction_date= data[ (auction_index + 2)..(auction_index + 4) ].join(' ')
      puts "Auction date -- #{auction_date}"
      insert_hash.merge!({:adate => auction_date })
      court_address = data[ (court_address_index + 10)..(court_address_index + 18)].join(' ')
      puts "Court address -- #{court_address}"
      court_address1 = data[ (court_address_index + 10)..(court_address_index + 13)].join(' ')
      court_address2 = data[ (court_address_index + 14)..(court_address_index + 16)].join(' ')
      court_address3 = data[ (court_address_index + 17)]
      insert_hash.merge!({:caddress1 => court_address1, :caddress2 => court_address2,:ccity => court_address3})
    end
      
    if link_data.include? 'Unit No.'
      unit_index = data.index 'Unit'
      unit_number = data[(unit_index + 2)..(unit_index + 7)].join(' ')
      puts  "Unit number -- #{unit_number}"
      insert_hash.merge!({:punit => unit_number})
    end
      
    if link_data.include? '(TMK'
      tmk_index = data.index '(TMK'
      tmk_number = data[(tmk_index + 2)..(tmk_index + 6)].join(' ')
      puts "TMK No -- #{tmk_number}"
      insert_hash.merge!({:tmk => tmk_number})
    end
    insert_hash.merge!({:adtext => link_data,:lfname => 'Johnson S. Chen', :docnumber => doc_no })
    Auction.create(insert_hash)
    ReweItem.get_address_from_tmk(tmk_number) unless tmk_number.nil?
      
  end
    
  def self.add_reject_data(link_data,doc_no)
    insert_hash = {:adtext => link_data, :doc_number => doc_no}
    Reject.create(insert_hash)
  end
      
  def self.truncate_tables(table_names)
    require 'active_record'
    #ActiveRecord::Base.configurations = Rails::Configuration.new.database_configuration

    begin
      config = ActiveRecord::Base.configurations[RAILS_ENV]
      ActiveRecord::Base.establish_connection
      logger.info(config["adapter"].inspect)
      case config["adapter"]
      when "mysql"
        table_names.each do |table|
          ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
        end
      when "sqlite", "sqlite3"
        table_names.each do |table|
          ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
          ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{table}'")
        end                                                                                                                               
        ActiveRecord::Base.connection.execute("VACUUM")
      end
    rescue
      $stderr.puts "Error while truncating. Make sure you have a valid database.yml file and have created the database tables before running this command. You should be able to run rake db:migrate without an error"
    end
    #  table_names.each do |name|
    #    ActiveRecord::Base.connection.execute("Truncate #{name}")
    #  end
          
  end
        
  def self.get_address_from_tmk(tmk)
    # Start mechanize
    agent = Mechanize.new
    agent.keep_alive = true
      
    if tmk.length > 4
      tmk = tmk.gsub!(/[\(\)\-' ']/,'')
      tmk = tmk.slice(1,12)
      
      agent.get('http://honolulupropertytax.com/Search/GenericSearch.aspx?mode=PARID') do |page|
        res = page.form_with(:name => 'frmMain') do |f|
          f.field_with(:name => 'inpParid').value = tmk
        end.submit
      
        if res.form_with(:name => 'frmMain').field_with(:name => 'hdLink')  != nil
          res1 = res.form_with(:name => 'frmMain') do |f|
            f.field_with(:name =>'hdLink').value = '../Forms/Datalets.aspx?idx=1&sIndex=1'
            f.field_with(:name =>'hdAction').value = 'Link'
            f.action = "GenericSearch.aspx?mode="+"PARID"
          end.submit
          url = "http://honolulupropertytax.com/Forms/PrintDatalet.aspx?pin="
          res1.form_with(:name => 'frmMain') do |f|
            url += tmk
            url += "&gsp=" + f.field_with(:name => 'hdGsp').value
            url += "&taxyear=" + f.field_with(:name => 'hdTaxYear').value
            url += "&jur=000" 
            url += "&ownseq=1"
            url += "&card=1" 
            url += "&State=1" 
            url += "&item=1" 
            url += "&items=-1"
            url += "&all=all"
            url += "&ranks=Datalet"
          end
        
          puts url
          owner_hash = {}
          res2 =  agent.get(url)
          name =    res2.parser.xpath("//table[@class='WidgetBar']//tr/td[@class='DataletHeaderBottom']")[1].inner_html
          owner_hash.merge!({:owner_name => name})
          parcel_data =  res2.parser.xpath("//table[@class='WidgetBar']//tr[2]/td/table[2]//td[@class='DataletData']/font")
          parcel_data.each_with_index do |n,i|
            owner_hash.merge!({:tmk => n.inner_html}) if i == 0
            owner_hash.merge!({:site_address => n.inner_html}) if i == 1
            owner_hash.merge!({:apartment_no => n.inner_html}) if i == 2
            owner_hash.merge!({:property_class => n.inner_html}) if i == 3
            owner_hash.merge!({:total_parcel_area => n.inner_html}) if i == 4
            owner_hash.merge!({:zoning => n.inner_html}) if i == 5
          end
          Owner.create(owner_hash)
        end
      end
    end
  end
        
        
      
end






