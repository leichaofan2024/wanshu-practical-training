class TTeamInfoesController < ApplicationController
    def index
        @duan = TDuanInfo.find(params[:duan])
        @station = TStationInfo.find(params[:station])
        @teams = TTeamInfo.where(F_station_uuid: params[:station])
    end

    def team_student_info
      @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.find_by(F_name: params[:name])
        @team_student = TUserInfo.student_all.joins(:t_team_info).where('t_team_info.F_station_uuid = ?', TStationInfo.find_by(F_name: params[:name]).F_uuid).select('t_user_info.F_id,t_team_info.F_name').distinct.group('t_team_info.F_name').size
        gon.key = @team_student.keys
        gon.value = @team_student.values
        @team_student_ck = TUserInfo.student_all.joins(:t_team_info, :t_record_infoes).where('t_team_info.F_station_uuid = ?', TStationInfo.find_by(F_name: params[:name]).F_uuid).select('t_user_info.F_id,t_team_info.F_name').distinct.group('t_team_info.F_name').size
        gon.ckvalue = @team_student_ck.values
    end

    def team_score_info
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.find_by(F_name: params[:name])
        @team_90_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', TStationInfo.find_by(F_name: params[:name]).F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ?', 90).group('t_team_info.F_name').size
        @team_80_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', TStationInfo.find_by(F_name: params[:name]).F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_team_info.F_name').size
        @team_60_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', TStationInfo.find_by(F_name: params[:name]).F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_team_info.F_name').size
        @team_60_bellow_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', TStationInfo.find_by(F_name: params[:name]).F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score < ?', 60).group('t_team_info.F_name').size
        gon.team_key = @team_90_scores.keys
        gon.ninefen = @team_90_scores.values
        gon.ef = @team_80_scores.values
        gon.sf = @team_60_scores.values
        gon.sb = @team_60_bellow_scores.values
    end
end
