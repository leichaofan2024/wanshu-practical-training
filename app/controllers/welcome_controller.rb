class WelcomeController < ApplicationController


  def ju_overview
      if current_user.permission == 2
        redirect_to duan_overview_path
      elsif current_user.permission == 3
        redirect_to station_overview
      end
  end

  def duan_ck
    duan = TDuanInfo.where.not("F_name = ? OR F_name = ?", "运输处","局职教基地")
    @ck_duans = duan.joins(:t_record_infoes).distinct(:F_uuid).select(:F_name).map{|a| a.F_name}
    @wk_duans = duan.select(:F_name).map{|a| a.F_name} - @ck_duans
  end

  def station_ck
    if current_user.permission == 1
      station = TDuanInfo.where.not(:F_name => ["运输处", "局职教基地"]).joins(:t_station_infoes).select("t_station_info.F_name,t_station_info.F_uuid")
      @ck_stations = station.joins(:t_record_infoes).distinct.pluck("t_station_info.F_name")
      @wk_stations = station.map{|s| s.F_name} - @ck_stations
    elsif current_user.permission ==2
      station = TStationInfo.where(:F_duan_uuid => TDuanInfo.find_by(:F_name => crrent_user.orgnize).F_uuid )
      @ck_stations = station.joins(t_user_infoes: :t_record_infoes).distinct.pluck("t_station_info.F_name")
      @wk_stations = station.pluck("t_station_info.F_name") - @ck_stations
    end
  end

  def team_ck
    if current_user.permission == 1
      team = TDuanInfo.where("t_duan_info.F_name != '运输处' AND t_duan_info.F_name != '局职教基地'").joins(t_station_infoes: :t_team_infoes).select("t_team_info.F_name","t_team_info.F_uuid")
      @ck_teams = team.joins(:t_record_infoes).distinct("t_team_info.F_uuid").pluck("t_team_info.F_name,t_team_info.F_uuid")
      @wk_teams = team.pluck("t_team_info.F_name,t_team_info.F_uuid") - @ck_teams
    elsif current_user.permission == 2
      team = TTeamInfo.joins(t_station_info: :t_duan_info).where("t_duan_info.F_name=?", current_user.orgnize).select("t_team_info.F_name","t_team_info.F_uuid")
      @ck_teams = team.joins(t_user_infoes: :t_record_infoes).distinct.pluck("t_team_info.F_name,t_team_info.F_uuid")
      @wk_teams = team.pluck("t_team_info.F_name,t_team_info.F_uuid") - @ck_teams
    end
  end

  def student_ck
    if current_user.permission == 1
      students = TUserInfo.student_all
      @ck_students = students.joins(:t_record_infoes).select("t_user_info.F_name,t_user_info.F_id").distinct.pluck(:F_name,:F_id)
      all_students = students.select("t_user_info.F_name,t_user_info.F_id").distinct.pluck(:F_name,:F_id)
      @wk_students = all_students - @ck_students
    elsif current_user.permission == 2
      students = TUserInfo.student_all
      @ck_students = students.joins(:t_duan_info,:t_record_detail_infoes).where("t_duan_info.F_name= ?",current_user.orgnize ).select("t_user_info.F_name,t_user_info.F_id").distinck.pluck(:F_name,:F_id)
      all_students = students.select("t_user_info.F_name,t_user_info.F_id").distinck.pluck(:F_name,:F_id)
      @wk_students = all_students - @ck_students
    end
  end

  def program_ck
    if current_user.permission == 1
      @ck_programs = TProgramInfo.joins(:t_record_detail_infoes).select(:F_name).distinct.pluck(:F_name)
      @wk_programs = TProgramInfo.pluck(:F_name) - @ck_programs
    elsif current_user.permission == 2
      @ck_programs = TProgramInfo.joins(t_record_detail_infoes: {t_record_info: :t_duan_info}).where("t_duan_info.F_name= ?", current_user.orgnize).select(:F_name).distinct.pluck(:F_name)
      @wk_programs = TProgramInfo.pluck(:F_name) - @ck_programs
    end
  end
end
