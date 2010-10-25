class AuctionsController < ApplicationController
  require 'mechanize'
  require 'parser'
  # GET /auctions
  # GET /auctions.xml
  def index
    @auctions = Auction.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @auctions }
    end
  end

  # GET /auctions/1
  # GET /auctions/1.xml
  def show
    @auction = Auction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @auction }
    end
  end

  # GET /auctions/new
  # GET /auctions/new.xml
  def new
    @auction = Auction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @auction }
    end
  end

  # GET /auctions/1/edit
  def edit
    @auction = Auction.find(params[:id])
  end

  # POST /auctions
  # POST /auctions.xml
  def create
    @auction = Auction.new(params[:auction])

    respond_to do |format|
      if @auction.save
        format.html { redirect_to(@auction, :notice => 'Auction was successfully created.') }
        format.xml  { render :xml => @auction, :status => :created, :location => @auction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @auction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /auctions/1
  # PUT /auctions/1.xml
  def update
    @auction = Auction.find(params[:id])

    respond_to do |format|
      if @auction.update_attributes(params[:auction])
        format.html { redirect_to(@auction, :notice => 'Auction was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @auction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /auctions/1
  # DELETE /auctions/1.xml
  def destroy
    @auction = Auction.find(params[:id])
    @auction.destroy

    respond_to do |format|
      format.html { redirect_to(auctions_url) }
      format.xml  { head :ok }
    end
  end
  
  def parse_ads
      @no_of_records = 0
      @rejected_records = 0
      # Start mechanize
      agent = Mechanize.new
      agent.keep_alive = true
 

      agent.get('http://secure.adpay.com/searchresults.aspx?catid=1004&pid=30317542665635565749382B643066356B6951776E673D3D') do |page|
        res = page.form_with(:name => 'Form1') do |f|
          f.field_with(:name => 'RadGridItems:_ctl1:_ctl2:_ctl1:ddlResults').value = 100
        end.submit
        

        doc = res.parser
       links = []
      doc.css('.SearchResultsOnlineAd a').each do |l|
          #puts " => Getting #{l['href']}"
          links << l.inner_html
         # puts l.inner_text
        end
      puts links.length
      @no_of_records = links.length
      links.each_with_index do |link,index|
            if link.include?('Bryson')
              puts "---------parsing record no #{index+1}, lawyer name - Bryson--------------"
              ReweItem.parse_bryson_format(link,index+1)
            elsif link.include?('Derek Wong')
              puts "---------parsing record no #{index+1}, lawyer name - Derek Wong--------------"  
              ReweItem.parse_derek_format(link,index+1)
            elsif link.include?('David B. Rosen')
              puts "---------parsing record no #{index+1}, lawyer name - David B. Rosen--------------"  
              ReweItem.parse_david_format(link,index+1)
            elsif link.include?('Michael R. Daniels')
              puts "---------parsing record no #{index+1}, lawyer name - Michael R. Daniels--------------"
              ReweItem.parse_michael_format(link,index+1)
            elsif link.include?('Johnson S. Chen')
              puts "---------parsing record no #{index+1}, lawyer name - Johnson S. Chen--------------"
              ReweItem.parse_johnson_format(link,index+1)
            else
              puts "---------- prasing record no #{index+1}  rejected----------"      
              ReweItem.add_reject_data(link,index+1)
              @rejected_records += 1
            end  
      end





      end
      @no_of_records -= @rejected_records
  end
  
end
