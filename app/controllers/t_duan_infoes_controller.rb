class TDuanInfoesController < ApplicationController
    def index; end

    def duan_student_info
        @duans = TDuanInfo.where.not(F_name: %w(运输处 局职教基地))
        @duans_student =  TUserInfo.where(F_type: 0).distinct(:F_id).joins(:t_duan_info).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').group('t_duan_info.F_name').size
        @duans_student_ck = TUserInfo.where(F_type: 0).joins(:t_duan_info, :t_record_infoes).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').select('t_duan_info.F_name, t_user_info.F_id').distinct('t_user_info.F_id').group('t_duan_info.F_name').size
    end

    def duan_score_info
        @duan_90_scores = TDuanInfo.joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score > ?', 90).group('t_duan_info.F_name').size
        @duan_80_scores = TDuanInfo.joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_duan_info.F_name').size
        @duan_60_scores = TDuanInfo.joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_duan_info.F_name').size
        @duan_60_bellow_scores = TDuanInfo.joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score < ?', 60).group('t_duan_info.F_name').size
    end

    def duan_program_info
        @duan_programs = TProgramInfo.joins(:t_record_detail_infoes).group('t_program_info.F_name').size.sort { |a, b| b[1] <=> a[1] }
    end

    def duan_program_student_info
        @records = TRecordInfo.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).joins(t_record_detail_infoes: :t_program_info).where('t_program_info.F_name = ?', params[:name])
    end

    def duan_reason_info
        @duan_reasons = TReasonInfo.joins(:t_detail_reason_infoes).group('t_reason_info.F_name').size.sort { |a, b| b[1] <=> a[1] }
    end

    def duan_reason_student_info
        @records = TRecordInfo.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).joins(t_record_detail_infoes: { t_detail_reason_infoes: :t_reason_info }).where('t_reason_info.F_name = ?', params[:name])
    end

    private

    def t_duan_info_params
        params.require(:t_duan_info).permit(:F_name, :F_type, :LEVEL)
    end
end
