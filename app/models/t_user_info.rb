class TUserInfo < ApplicationRecord
  self.table_name = "t_user_info"
  belongs_to :t_work_info,:class_name => "TWorkInfo",:foreign_key => "F_work_uuid"
  belongs_to :t_duan_info,:class_name =>"TDuanInfo", :foreign_key => "F_duan_uuid"
  belongs_to :t_station_info,:class_name =>"TStationInfo", :foreign_key => "F_station_uuid"
  belongs_to :t_team_info,:class_name =>"TTeamInfo", :foreign_key => "F_team_uuid"
  has_many :t_record_infoes, :foreign_key => "F_user_uuid",dependent: :destroy


end
