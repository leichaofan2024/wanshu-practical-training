class TTeamInfo < ApplicationRecord
  self.table_name = "t_team_info"
  belongs_to :t_station_info, :class_name => "TStationInfo", :foreign_key => "F_station_uuid"

end
