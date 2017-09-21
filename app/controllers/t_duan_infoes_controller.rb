class TDuanInfoesController < ApplicationController
    def index
        @duans_cw = TDuanInfo.duan_orgnization.where(F_type: 1)
        @duans_zs = TDuanInfo.duan_orgnization.where(F_type: 2)
        @duans_zj = TDuanInfo.duan_zhijiao
    end

    def duan_student_info
        @duans = TDuanInfo.where.not(F_name: %w(运输处 局职教基地))
        @duans_student_cw = TUserInfo.where(F_type: 0).joins(:t_duan_info).where.not('t_duan_info.F_name =? or t_duan_info.F_name =? ', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').group('t_duan_info.F_name').size
        @duans_student_zs = TUserInfo.where(F_type: 0).joins(:t_duan_info).where.not('t_duan_info.F_name =? or t_duan_info.F_name =? ', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            cw = @search.scope_duan_student.where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name')
            zs = @search.scope_duan_student.where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name')
            @duans_student_cw_ck = cw.count
            @duans_student_cw_wk = TUserInfo.where(F_type: 0).joins(:t_duan_info).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').where.not('t_user_info.F_id' => cw.pluck('t_user_info.F_id')).distinct.group('t_duan_info.F_name').count

            @duans_student_zs_ck = zs.count
            @duans_student_zs_wk = TUserInfo.where(F_type: 0).joins(:t_duan_info).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').where.not('t_user_info.F_id' => zs.pluck('t_user_info.F_id')).distinct.group('t_duan_info.F_name').size

        else
            cw = TUserInfo.where(F_type: 0).joins(:t_duan_info, :t_record_infoes).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name')
            zs = TUserInfo.where(F_type: 0).joins(:t_duan_info, :t_record_infoes).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name')
            @duans_student_cw_ck = cw.count
            @duans_student_cw_wk = TUserInfo.where(F_type: 0).joins(:t_duan_info).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').where.not('t_user_info.F_id' => cw.pluck('t_user_info.F_id')).distinct.group('t_duan_info.F_name').count

            @duans_student_zs_ck = zs.count
            @duans_student_zs_wk = TUserInfo.where(F_type: 0).joins(:t_duan_info).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').where.not('t_user_info.F_id' => zs.pluck('t_user_info.F_id')).distinct.group('t_duan_info.F_name').count

      end
        gon.cwkey = @duans_student_cw.keys
        gon.cwwkvalue = @duans_student_cw_wk.values
        gon.cwckvalue = @duans_student_cw_ck.values

        gon.zskey = @duans_student_zs.keys
        gon.zswkvalue = @duans_student_zs_wk.values
        gon.zsckvalue = @duans_student_zs_ck.values
    end

    def duan_score_info
        @duantype1 = TDuanInfo.where('t_duan_info.F_type= ?', 1).joins(t_user_infoes: :t_record_infoes)
        @duantype2 = TDuanInfo.where('t_duan_info.F_type= ?', 2).joins(t_user_infoes: :t_record_infoes)
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            @duan_90_cwscores = @search.scope_duan_score1.where('t_record_info.F_score > ?', 90).group('t_duan_info.F_name').size
            @duan_80_cwscores = @search.scope_duan_score1.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_duan_info.F_name').size
            @duan_60_cwscores = @search.scope_duan_score1.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_duan_info.F_name').size
            @duan_60_cwbellow_scores = @search.scope_duan_score1.where('t_record_info.F_score < ?', 60).group('t_duan_info.F_name').size
            @duan_90_zsscores = @search.scope_duan_score2.where('t_record_info.F_score > ?', 90).group('t_duan_info.F_name').size
            @duan_80_zsscores = @search.scope_duan_score2.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_duan_info.F_name').size
            @duan_60_zsscores = @search.scope_duan_score2.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_duan_info.F_name').size
            @duan_60_zsbellow_scores = @search.scope_duan_score2.where('t_record_info.F_score < ?', 60).group('t_duan_info.F_name').size
        else
            @duan_90_cwscores = @duantype1.where('t_record_info.F_score > ?', 90).group('t_duan_info.F_name').size
            @duan_80_cwscores = @duantype1.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_duan_info.F_name').size
            @duan_60_cwscores = @duantype1.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_duan_info.F_name').size
            @duan_60_cwbellow_scores = @duantype1.where('t_record_info.F_score < ?', 60).group('t_duan_info.F_name').size
            @duan_90_zsscores = @duantype2.where('t_record_info.F_score > ?', 90).group('t_duan_info.F_name').size
            @duan_80_zsscores = @duantype2.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_duan_info.F_name').size
            @duan_60_zsscores = @duantype2.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_duan_info.F_name').size
            @duan_60_zsbellow_scores = @duantype2.where('t_record_info.F_score < ?', 60).group('t_duan_info.F_name').size
      end
        gon.duan_key = @duan_90_cwscores.keys
        gon.ninefen = @duan_90_cwscores.values
        gon.ef = @duan_80_cwscores.values
        gon.sf = @duan_60_cwscores.values
        gon.sb = @duan_60_cwbellow_scores.values
        gon.zsduan_key = @duan_90_zsscores.keys
        gon.zsnf = @duan_90_zsscores.values
        gon.zsef = @duan_80_zsscores.values
        gon.zssf = @duan_60_zsscores.values
        gon.zssb = @duan_60_zsbellow_scores.values
    end

    def duan_program_info
        @duan_programs = TProgramInfo.joins(:t_record_detail_infoes).group('t_program_info.F_name').size.sort { |a, b| b[1] <=> a[1] }
    end

    def duan_program_student_info
        @records = TRecordInfo.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).joins(t_record_detail_infoes: :t_program_info).where('t_program_info.F_name = ?', params[:name])
    end

    def duan_reason_info
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            @duan_reasons = @search.scope_duan_reason.size.sort { |a, b| b[1] <=> a[1] }
        else
            @duan_reasons = TReasonInfo.joins(:t_detail_reason_infoes).group('t_reason_info.F_name').size.sort { |a, b| b[1] <=> a[1] }
        end
        @t = request.query_parameters
        @h = hash_to_query(@t)
    end
    require 'uri'
    def hash_to_query(hash)
        URI.encode_www_form(hash)
    end

    def duan_reason_student_info
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            @records = @search.scope_duan_reason_student(params[:name])
        else
            @records = TRecordInfo.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).joins(t_record_detail_infoes: { t_detail_reason_infoes: :t_reason_info }).where('t_reason_info.F_name = ?', params[:name])
        end
    end

    private

    def t_duan_info_params
        params.require(:t_duan_info).permit(:F_name, :F_type, :LEVEL)
    end
end
