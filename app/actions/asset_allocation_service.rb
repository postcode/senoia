class AssetAllocationService

  def initialize(args)
    @type = args[:type]
    @crowd_size = args[:crowd_size]
    @text = {}
  end

  def asset_text
    calculate_first_aid_stations
    @text
  end

  private

  def calculate_first_aid_stations
    if @type.name == "Concert or Music Festival" || "Athletic or Sporting Event"
      @crowd_size > 2500 ? @text[:first_aid_station] = "You will need 1 or more First Aid Stations." : @text[:first_aid_station] = "You will need at least 1 First Aid Station."
    else
      @text[:first_aid_station] = "It is recommended that you have 1 or more First Aid Stations."
    end
  end

end
