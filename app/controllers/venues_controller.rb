class VenuesController < ApplicationController
  load_and_authorize_resource

  def index
    @venue_grid = initialize_grid(Venue,
                                  order: 'name',
                                  custom_order: {
                                    'venues.name' => 'lower(?)'
                                  },
                                  order_direction: 'asc'
                                 )
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def new
    respond_to do |format|
      format.html
      format.json { render json: @venue }
    end
  end

  def create
    @venue = Venue.new(venue_params)
    if !@venue.save
      render action: :new
    else
      redirect_to action: :index
    end
  end

  def update
    if !@venue.update(venue_params)
      render action: :edit
    else
      redirect_to action: :index
    end
  end

  private

  def venue_params
    params.require(:venue).permit(:name)
  end
end
