class TTeamInfo < ApplicationRecord
  self.table_name = "t_team_info"
  belongs_to :t_station_info, :class_name => "TStationInfo", :foreign_key => "F_station_uuid"
  has_many :t_record_infoes, :foreign_key => "F_team_uuid"
  has_many :t_user_infoes ,:class_name => "TUserInfo" ,:foreign_key => "F_team_uuid"

end
