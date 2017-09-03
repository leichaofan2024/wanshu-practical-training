class WelcomeController < ApplicationController

  def duan_ck
    duan = TDuanInfo.where.not("F_name = ? OR F_name = ?", "运输处","局职教基地")
    @ck_duans = duan.joins(:t_record_infoes).distinct(:F_uuid).select(:F_name).map{|a| a.F_name}
    @wk_duans = duan.select(:F_name).map{|a| a.F_name} - @ck_duans
  end

  def station_ck
    station = TDuanInfo.where.not(:F_name => ["运输处", "局职教基地"]).joins(:t_station_infoes).select("t_station_info.F_name,t_station_info.F_uuid")
    @ck_stations = station.joins(:t_record_infoes).distinct(:F_uuid).select("t_station_info.F_name").map{|a| a.F_name}
    @wk_stations = station.map{|s| s.F_name} - @ck_stations
  end

  def team_ck
    team = TDuanInfo.where("t_duan_info.F_name != '运输处' AND t_duan_info.F_name != '局职教基地'").joins(t_station_infoes: :t_team_infoes).select("t_team_info.F_name","t_team_info.F_uuid")
    @ck_teams = team.joins(:t_record_infoes).distinct("t_team_info.F_uuid").select("t_team_info.F_name").map{|t| t.F_name}
    @wk_teams = team.map{|t| t.F_name} - @ck_teams
  end

  def student_ck
  
  end

end
