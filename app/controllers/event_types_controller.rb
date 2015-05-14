class EventTypesController < ApplicationController

  def index
    @events = EventType.all
    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

  def show
    @event = EventType.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @event = EventType.new
    respond_to do |format|
      format.html
      format.json { render json: @event }
    end
  end  

  def create
    @event = EventType.new(event_type_params)
    if @event.save
      redirect_to event_types_path
    else
      redirect_to event_type_new(@event), alert: @event.errors
    end
  end

  private 

   # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    def event_type_params
      params.require(:event_type).permit(:name, :start_date, :end_date, :description)
    end
end
