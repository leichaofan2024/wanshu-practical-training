class XcfUserInfo < ApplicationRecord
  has_many :xcf_record_infoes, :foreign_key => "F_user_uuid",dependent: :destroy
  belongs_to :t_duan_info, class_name: "TDuanInfo",:foreign_key => "F_duan_uuid"
  belongs_to :t_station_info, class_name: "TStationInfo", :foreign_key => "F_station_uuid"
  belongs_to :t_team_info, class_name: "TTeamInfo", :foreign_key => "F_team_uuid",optional: true
  belongs_to :t_work_info, class_name: "TWorkInfo", :foreign_key => "F_work_uuid"
end
