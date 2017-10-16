class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.inheritance_column = "_type"



  scope :duan_zhijiao, -> {where("t_duan_info.F_name = ? OR t_duan_info.F_name =?", "运输处", "局职教基地")}
  scope :duan_orgnization, -> {where.not("t_duan_info.F_name = ? OR t_duan_info.F_name =?", "运输处", "局职教基地")}
  scope :station_zhijiao, -> {where("t_station_info.F_duan_uuid=? OR t_station_info.F_duan_uuid=?", TDuanInfo.duan_zhijiao.first.F_uuid ,TDuanInfo.duan_zhijiao.last.F_uuid)}
  scope :station_orgnization, -> {where.not(:F_duan_uuid => [TDuanInfo.duan_zhijiao.first.F_uuid,TDuanInfo.duan_zhijiao.last.F_uuid])}
  scope :team_zhijiao, -> {joins(t_station_info: :t_duan_info).duan_zhijiao}
  scope :team_orgnization, -> {joins(t_station_info: :t_duan_info).duan_orgnization}
  scope :student_all , -> {where("t_user_info.F_type": 0)}
  scope :datetime, -> {where('t_record_info.F_time BETWEEN ? AND ?', Date.today.beginning_of_month, Date.today.end_of_month)}
  scope :datetime1, -> {where('F_time BETWEEN ? AND ?', Date.today.beginning_of_month, Date.today.end_of_month)}

  
end
