class ListingsController < ApplicationController
  layout 'board'
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_employer!, only: [:new, :create]

  # GET /listings
  # GET /listings.json
  def index
    @search = Listing.search(params[:q])

    @listings = Listing.all.where(board: @board)
    if params[:q].present?
      @listings = @search.result.where(board: @board)
    end

    if params[:location].present?
      @listings = @listings.near(params[:location]).where(board: @board)
    end

    @listings = @listings.paginate(:page => params[:page], :per_page => 30)
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
  end

  # GET /listings/new
  def new
    @listing = current_employer.listings.build
    # @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings
  # POST /listings.json
  def create
    # @listing = Listing.new(listing_params)
    @listing = current_employer.listings.build(listing_params)
    @listing.board_id = @board.id
    
    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: 'Listing was successfully created.' }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listings/1
  # PATCH/PUT /listings/1.json
  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find_by!(id: params[:id], board: @board)
    rescue
      flash[:alert] = "Listing could not be found"
      redirect_to root_path
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_params
      params.require(:listing).permit(:board_id, :employer_id, :company_id, :job_title, :job_description, :job_location, :job_type, :job_url, :contact_email)
    end
end
