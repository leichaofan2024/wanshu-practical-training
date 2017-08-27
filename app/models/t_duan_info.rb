class TDuanInfo < ApplicationRecord
  self.table_name = "t_duan_info"
  has_many :t_station_infoes,:class_name => "TStationInfo",:foreign_key => "F_duan_uuid"
  has_many :t_user_infoes ,:class_name => "TUserInfo" ,:foreign_key => "F_duan_uuid"
  has_many :t_record_infoes, :foreign_key => "F_duan_uuid"







end
