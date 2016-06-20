class AssetAllocationService

  def initialize(args)
    @type = args[:type]
    @crowd_size args[:crowd_size]
    @text
  end

  def asset_text
    calculate_first_aid_stations
    @text
  end

  private

  def calculate_first_aid_stations
    if @type.name == "Concert or Music Festival"
      @crowd_size > 2500 ? @text = "You will need 1 or more First Aid Stations." : @text = "You will need at least 1 First Aid Station."
    end
  end

end
