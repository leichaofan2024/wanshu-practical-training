class TVacationInfo < ApplicationRecord

  def self.student_long_vacation(begin_time,end_time)
    a = TVacationInfo.where("t_vacation_infos.F_type = ? and t_vacation_infos.begin_time between ? and ?","长假",begin_time, end_time).pluck(:F_id).uniq
    b = TVacationInfo.where("t_vacation_infos.F_type = ? and t_vacation_infos.begin_time < ? and t_vacation_infos.end_time > ?","长假",begin_time, end_time).pluck(:F_id).uniq
    c = TVacationInfo.where("t_vacation_infos.end_time": nil).where("t_vacation_infos.F_type = ? and t_vacation_infos.begin_time < ?", "长假", begin_time).pluck(:F_id).uniq
    return a + b + c
  end

  def self.student_short_vacation(begin_time,end_time)
    a = TVacationInfo.where("t_vacation_infos.F_type = ? and t_vacation_infos.begin_time between ? and ?","短假",begin_time, end_time).pluck(:F_id).uniq
    b = TVacationInfo.where("t_vacation_infos.F_type = ? and t_vacation_infos.begin_time < ? and t_vacation_infos.end_time > ?","短假",begin_time, end_time).pluck(:F_id).uniq
    c = TVacationInfo.where("t_vacation_infos.end_time": nil).where("t_vacation_infos.F_type = ? and t_vacation_infos.begin_time < ?", "短假", begin_time).pluck(:F_id).uniq
    return a + b + c
  end

  def self.student_transfer(begin_time,end_time)
    a = TVacationInfo.all.where("t_vacation_infos.F_type = ? and t_vacation_infos.begin_time between ? and ?","调离",begin_time, end_time).select(:station_name,:F_id).distinct
      x = []
      a.each do |aa|
        x += TUserInfo.where(:F_station_uuid => TStationInfo.find_by(:F_name => aa.station_name).F_uuid ,:F_id => aa.F_id).pluck(:F_uuid)
      end
    b = TVacationInfo.all.where("t_vacation_infos.F_type = ? and t_vacation_infos.begin_time < ? and t_vacation_infos.end_time > ?","调离",begin_time, end_time).select(:station_name,:F_id).distinct
      y = []
      b.each do |bb|
        y += TUserInfo.where(:F_station_uuid => TStationInfo.find_by(:F_name => bb.station_name).F_uuid ,:F_id => bb.F_id).pluck(:F_uuid)
      end
    c = TVacationInfo.where("t_vacation_infos.end_time": nil).where("t_vacation_infos.F_type = ? and t_vacation_infos.begin_time < ?", "调离", begin_time).select(:station_name,:F_id).distinct
      z = []
      c.each do |cc|
        z += TUserInfo.where(:F_station_uuid => TStationInfo.find_by(:F_name => cc.station_name).F_uuid ,:F_id => cc.F_id).pluck(:F_uuid)
      end

    return x + y + z
  end

end
