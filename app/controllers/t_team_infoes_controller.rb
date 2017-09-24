class TTeamInfoesController < ApplicationController
    def index
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.find_by(F_name: params[:station_name])
        @teams = TTeamInfo.where(F_station_uuid: @station.F_uuid)
    end

    def team_student_info
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.find_by(F_name: params[:station_name])
        @team_student = TUserInfo.student_all.joins(:t_team_info).where('t_team_info.F_station_uuid = ?', @station.F_uuid).select('t_user_info.F_name,t_user_info.F_id,t_team_info.F_name').distinct.group('t_team_info.F_name').count
        if params[:team_name].present?
            @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
            @student_ck = TUserInfo.student_all.joins(:t_team_info, :t_record_infoes).where('t_team_info.F_uuid =? ', @team.F_uuid).select(:F_name, :F_id).distinct
            @student_wk = TUserInfo.student_all.joins(:t_team_info).where('t_team_info.F_uuid=?', @team.F_uuid).select(:F_name, :F_id).distinct.where.not(F_id: @student_ck.pluck(:F_id))
        end

        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_team_student(params[:station_name]).select('t_user_info.F_name,t_user_info.F_id,t_team_info.F_name').distinct.group('t_team_info.F_name')
            @team_student_ck = m.count
            @team_student_wk = TUserInfo.student_all.joins(:t_team_info).where('t_team_info.F_station_uuid = ?', @station.F_uuid).select('t_user_info.F_name,t_user_info.F_id,t_team_info.F_name').where.not('t_user_info.F_id' => m.pluck('t_user_info.F_id')).distinct.group('t_team_info.F_name').count
        else
            m = TUserInfo.student_all.joins(:t_team_info, :t_record_infoes).where('t_team_info.F_station_uuid = ?', @station.F_uuid).select('t_user_info.F_name,t_user_info.F_id,t_team_info.F_name').distinct.group('t_team_info.F_name')
            @team_student_ck = m.count.sort { |a, b| b <=> a }.to_h
            @team_student_wk = TUserInfo.student_all.joins(:t_team_info).where('t_team_info.F_station_uuid = ?', @station.F_uuid).select('t_user_info.F_name,t_user_info.F_id,t_team_info.F_name').where.not('t_user_info.F_id' => m.pluck('t_user_info.F_id')).distinct.group('t_team_info.F_name').count.sort { |a, b| b <=> a }.to_h
        end
        gon.key = @team_student.keys
        gon.wkvalue = @team_student_wk.values
        gon.ckvalue = @team_student_ck.values

        url = request.original_url
        arrurl = url.split('?')
        @para = arrurl[1]
    end

    def team_score_info
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.find_by(F_name: params[:station_name])
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            @team_90_scores = @search.scope_team_score(params[:station_name]).where('t_record_info.F_score >= ?', 90).group('t_team_info.F_name').count
            @team_80_scores = @search.scope_team_score(params[:station_name]).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_team_info.F_name').count
            @team_60_scores = @search.scope_team_score(params[:station_name]).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_team_info.F_name').count
            @team_60_bellow_scores = @search.scope_team_score(params[:station_name]).where('t_record_info.F_score < ?', 60).group('t_team_info.F_name').count

        else
            @team_90_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ?', 90).group('t_team_info.F_name').count
            @team_80_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_team_info.F_name').count
            @team_60_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_team_info.F_name').count
            @team_60_bellow_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score < ?', 60).group('t_team_info.F_name').count
        end
        gon.team_key = @team_90_scores.keys
        gon.ninefen = @team_90_scores.values
        gon.ef = @team_80_scores.values
        gon.sf = @team_60_scores.values
        gon.sb = @team_60_bellow_scores.values
    end
end
