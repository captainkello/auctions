class RejectsController < ApplicationController
  def index
  end
  
  def show
    @reject = Reject.find(params[:id])
  end
  

  def edit
    @reject = Reject.find(params[:id])
  end
  
  def update
    puts "asdfasdfasdfasdfasfasdfasdfasdfasdfasdfasdfa"
    @reject = Reject.find(params[:id])
     respond_to do |format|
      if @reject.update_attributes(params[:reject])
        format.html { redirect_to(@reject, :notice => 'Rejected auction  was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reject.errors, :status => :unprocessable_entity }
      end
    end
  end
  
def destroy
    @reject = Reject.find(params[:id])
    @reject.destroy

    respond_to do |format|
      format.html { redirect_to(auctions_url) }
      format.xml  { head :ok }
    end
  end
end
