class TStationInfoesController < ApplicationController
    def index
        @duan = TDuanInfo.find_by(F_name: params[:duan])
        @stations = TStationInfo.all.where(F_duan_uuid: @duan.F_uuid)
    end

    def edit
        @station = TStationInfo.find(params[:id])
    end

    def update
        @station = TStationInfo.find(params[:id])
        @duan = @station.t_duan_info
        if @station.update(t_station_info_params)
            redirect_to team_student_info_t_team_infoes_path(duan_name: @duan.F_name, name: @station.F_name)
        else
            return :back
        end
    end

    def station_student_info
        @duan = TDuanInfo.find_by(F_name: params[:name])
        @m = TUserInfo.student_all.joins(:t_station_info, :t_record_infoes).where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params[:name]).F_uuid).select('t_user_info.F_id,t_station_info.F_name')
        @station_student = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params[:name]).F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.group('t_station_info.F_name').size

        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            @station_student_wk = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params[:name]).F_uuid).select('t_user_info.F_id,t_station_info.F_name').where.not('t_user_info.F_id' => @m.pluck('t_user_info.F_id')).distinct.group('t_station_info.F_name').size
            @station_student_ck = @search.scope_student_info.select('t_user_info.F_id,t_station_info.F_name').distinct.group('t_station_info.F_name').size
        else
            @station_student_wk = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params[:name]).F_uuid).select('t_user_info.F_id,t_station_info.F_name').where.not('t_user_info.F_id' => @m.pluck('t_user_info.F_id')).distinct.group('t_station_info.F_name').size
            @station_student_ck = TUserInfo.student_all.joins(:t_station_info, :t_record_infoes).where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params[:name]).F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.group('t_station_info.F_name').size
        end
        gon.key = @station_student.keys
        gon.wkvalue = @station_student_wk.values
        gon.ckvalue = @station_student_ck.values
    end

    def station_score_info
        @duan = TDuanInfo.find_by(F_name: params[:name])
        @station_90_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params[:name]).F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ?', 90).group('t_station_info.F_name').size
        @station_80_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params[:name]).F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_station_info.F_name').size
        @station_60_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params[:name]).F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_station_info.F_name').size
        @station_60_bellow_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params[:name]).F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score < ?', 60).group('t_station_info.F_name').size
        gon.station_key = @station_90_scores.keys
        gon.ninefen = @station_90_scores.values
        gon.ef = @station_80_scores.values
        gon.sf = @station_60_scores.values
        gon.sb = @station_60_bellow_scores.values
    end

    private

    def t_station_info_params
        params.require(:t_station_info).permit(:F_name, :F_duan_uuid, :F_level, :Level, :image)
    end
end
