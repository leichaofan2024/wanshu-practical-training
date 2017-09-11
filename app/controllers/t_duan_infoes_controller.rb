class TDuanInfoesController < ApplicationController
    def index
      @duans_cw= TDuanInfo.duan_orgnization.where(:F_type => 1)
      @duans_zs= TDuanInfo.duan_orgnization.where(:F_type => 2)
      @duans_zj= TDuanInfo.duan_zhijiao
    end

    def duan_student_info
        @duans = TDuanInfo.where.not(F_name: %w(运输处 局职教基地))
        @duans_student_cw = TUserInfo.where(F_type: 0).joins(:t_duan_info).where.not('t_duan_info.F_name =? or t_duan_info.F_name =? ', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 1).select("t_duan_info.F_name, t_user_info.F_id").group('t_duan_info.F_name').size
        @duans_student_cw_ck = TUserInfo.where(F_type: 0).joins(:t_duan_info, :t_record_infoes).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').size

        @duans_student_zs = TUserInfo.where(F_type: 0).joins(:t_duan_info).where.not('t_duan_info.F_name =? or t_duan_info.F_name =? ', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 2).select("t_duan_info.F_name, t_user_info.F_id").group('t_duan_info.F_name').size
        @duans_student_zs_ck = TUserInfo.where(F_type: 0).joins(:t_duan_info, :t_record_infoes).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').size

        gon.cwkey = @duans_student_cw.keys
        gon.cwvalue = @duans_student_cw.values
        gon.cwckvalue = @duans_student_cw_ck.values
        gon.zskey = @duans_student_zs.keys
        gon.zsvalue = @duans_student_zs.values
        gon.zsckvalue = @duans_student_zs_ck.values
    end

    def duan_score_info
        @duan_90_cwscores = TDuanInfo.where('t_duan_info.F_type= ?', 1).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score > ?', 90).group('t_duan_info.F_name').size
        gon.duan_key = @duan_90_cwscores.keys
        gon.ninefen = @duan_90_cwscores.values
        @duan_80_cwscores = TDuanInfo.where('t_duan_info.F_type= ?', 1).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_duan_info.F_name').size
        gon.ef = @duan_80_cwscores.values
        @duan_60_cwscores = TDuanInfo.where('t_duan_info.F_type= ?', 1).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_duan_info.F_name').size
        gon.sf = @duan_60_cwscores.values
        @duan_60_cwbellow_scores = TDuanInfo.where('t_duan_info.F_type= ?', 1).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score < ?', 60).group('t_duan_info.F_name').size
        gon.sb = @duan_60_cwbellow_scores.values

        @duan_90_zsscores = TDuanInfo.where('t_duan_info.F_type= ?', 2).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score > ?', 90).group('t_duan_info.F_name').size
        gon.zsduan_key = @duan_90_zsscores.keys
        gon.zsnf = @duan_90_zsscores.values
        @duan_80_zsscores = TDuanInfo.where('t_duan_info.F_type= ?', 2).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_duan_info.F_name').size
        gon.zsef = @duan_80_zsscores.values
        @duan_60_zsscores = TDuanInfo.where('t_duan_info.F_type= ?', 2).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_duan_info.F_name').size
        gon.zssf = @duan_60_zsscores.values
        @duan_60_zsbellow_scores = TDuanInfo.where('t_duan_info.F_type= ?', 2).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score < ?', 60).group('t_duan_info.F_name').size
        gon.zssb = @duan_60_zsbellow_scores.values
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
