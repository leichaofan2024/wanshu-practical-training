module TTeamInfoesHelper
  def render_student_time_length(params,search,station)
    s = TStationInfo.find_by(:F_name => station)
    if search.present?
      t = TimeSearch.new(search)

      a = TRecordInfo.where("t_record_info.F_time between ? and ?",t.date_from,t.date_to).where(F_user_uuid: TUserInfo.where(:F_id => params.F_id,:F_station_uuid => s.F_uuid).pluck(:F_uuid)).sum("t_record_info.time_length")
      b = a%60
      c = (a - b)/60
      return "#{c}分#{b}秒"
    else
      a = TRecordInfo.where("t_record_info.F_time between ? and ?",Time.now.beginning_of_month+8.hours,Time.now.end_of_month+8.hours).where(F_user_uuid: TUserInfo.where(:F_id => params.F_id,:F_station_uuid => s.F_uuid).pluck(:F_uuid)).sum("t_record_info.time_length")
      b = a%60
      c = (a - b)/60
      return "#{c}分#{b}秒"
    end
  end
end
