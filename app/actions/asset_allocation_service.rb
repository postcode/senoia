class AssetAllocationService
  def initialize(args)
    @type = args[:type]
    args[:crowd_size].present? ? @crowd_size = args[:crowd_size] : @crowd_size = 0
    @text = {}
  end

  def asset_text
    calculate_first_aid_stations
    calculate_mobile_teams
    @text
  end

  private

  def calculate_first_aid_stations
    if @type.name == "Concert or Music Festival" || @type.name == "Athletic or Sporting Event"
      @crowd_size > 2500 ? @text[:first_aid_station] = "You will need 1 or more First Aid Stations." : @text[:first_aid_station] = "You will need at least 1 First Aid Station."
    else
      @text[:first_aid_station] = "It is recommended that you have 1 or more First Aid Stations."
    end
  end

  def calculate_mobile_teams
    if @type.name == "Athletic or Sporting Event" || @type.name == "Outside Parade, Block Party, or Street Fair"
      @text[:mobile_team] = "You will need 1 or more Mobile Teams." if @crowd_size > 2500
    elsif @type.name == "Water-based"
      @text[:mobile_team] = "You must have at least one water-based ALS response team in addition to your land-based team."
    else
      @text[:mobile_team] = "It is recommended that you have 1 or more Mobile Teams."
    end
  end
end
