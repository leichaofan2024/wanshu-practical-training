class TStationInfoesController < ApplicationController
    def index
        @stations = TStationInfo.all.where(F_duan_uuid: params[:duan])
    end

    def station_student_info
        @duan = TDuanInfo.find_by(F_name: params[:name])
        @station_student = TUserInfo.distinct(:F_id).joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params[:name]).F_uuid).group('t_station_info.F_name').size
        gon.key = @station_student.keys
        gon.value = @station_student.values
        @station_student_ck = TUserInfo.joins(:t_station_info, :t_record_infoes).where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params[:name]).F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct(:F_id).group('t_station_info.F_name').size
        gon.ckvalue = @station_student_ck.values
    end

    def station_score_info
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
        params.require(:t_station_info).permit(:F_name, :F_duan_uuid, :F_level, :Level)
    end
end
