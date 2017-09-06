class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    helper_method [:duan, :duan_z, :duan_cw, :duan_ju, :duan_ck_count, :station, :station_ck_count, :team, :team_ju, :team_ck_count, :student_wk_count, :students, :student_ck_count, :student_ck_counts, :teacher, :program_ck_count,
                   :score_90, :score_80, :score_60, :score_60_below, :program_type_percent, :reason_hot_all]
    def duan
        m = TDuanInfo.where.not('F_name= ? || F_name= ?', '局职教基地', '运输处').count
    end

    def duan_ck_count
        m = TDuanInfo.duan_orgnization.joins(t_user_infoes: :t_record_infoes).where('t_user_info.F_type = ?', 0).select('t_duan_info.F_uuid').distinct.count
    end

    def duan_z
        m = TDuanInfo.where(F_type: 2)
    end

    def duan_cw
        m = TDuanInfo.where(F_type: 1)
    end

    def duan_ju
        m = TDuanInfo.where('F_name = ? || F_name= ?', '局职教基地', '运输处')
    end

    def station
        m = TStationInfo.where.not('F_duan_uuid = ? || F_duan_uuid = ? ', duan_ju.first.F_uuid, duan_ju.last.F_uuid).count
    end

    def station_ju
        m = TStationInfo.includes(:t_record_infoes).where('F_duan_uuid = ? || F_duan_uuid = ? ', duan_ju.first.F_uuid, duan_ju.last.F_uuid)
    end

    def station_ck_count
        m = TStationInfo.joins(:t_record_infoes).select(:F_uuid).distinct.count
    end

    def team
        m = TDuanInfo.where.not(F_name: %w(运输处 局职教基地)).joins(t_station_infoes: :t_team_infoes).count
    end

    def team_ck_count
        m = TTeamInfo.joins(t_station_info: :t_duan_info).where.not("t_duan_info.F_name = '运输处' OR t_duan_info.F_name = '局职教基地'").joins(:t_record_infoes).distinct.count
    end

    def students
        m = TUserInfo.where(F_type: 0).select(:F_id).distinct.count
    end

    def student_ck_counts
        m = TUserInfo.where(F_type: 0).joins(:t_record_infoes).select(:F_id).distinct.count
    end

    def student_wk_count
        m = TUserInfo.where(F_type: 0).select(:F_id).distinct.count - TUserInfo.where(F_type: 0).joins(:t_record_infoes).select(:F_id).distinct.count
        s = {}
        s['未考人数'] = m
        @weikao = { name: '未考人数', value: s['未考人数'] }
        gon.weikao = @weikao
    end

    def student_ck_count
        m = TUserInfo.where(F_type: 0).joins(:t_record_infoes).select(:F_id).distinct.count
        result = {}
        result['实考人数'] = m
        @shikao = { name: '实考人数', value: result['实考人数'] }
        gon.shikao = @shikao
    end

    def teacher
        m = TUserInfo.where(F_type: 1)
    end

    def program_ck_count
        m = TProgramInfo.joins(:t_record_detail_infoes).distinct.count
    end

    def score_90
        m = TRecordInfo.where('F_score >= ?', 90).count
        result = {}
        result['90分以上'] = m
        @nine = { name: '90分以上', value: result['90分以上'] }
        gon.nine = @nine
    end

    def score_80
        m = TRecordInfo.where('F_score >= ? AND F_score<? ', 80, 90).count
        result = {}
        result['80分-90分'] = m
        @eight = { name: '80分-90分', value: result['80分-90分'] }
        gon.eight = @eight
    end

    def score_60
        m = TRecordInfo.where('F_score >= ? AND F_score<? ', 60, 80).count
        result = {}
        result['60分-80分'] = m
        @six = { name: '60分-80分', value: result['60分-80分'] }
        gon.six = @six
    end

    def score_60_below
        m = TRecordInfo.where('F_score< ? ', 60).count
        result = {}
        result['60分以下'] = m
        @below = { name: '60分以下', value: result['60分以下'] }
        gon.below = @below
    end

    def program_type_percent
        m = TProgramTypeInfo.joins(t_program_infoes: :t_record_detail_infoes).group(:F_name).size
        @yjcz = { name: '应急处置', value: m['应急处置'] }
        gon.yj = @yjcz
        @zcjf = { name: '正常接发车办理科目', value: m['正常接发车办理科目'] }
        gon.zc = @zcjf
        @fzcfche = { name: '非正常发车办理科目', value: m['非正常发车办理科目'] }
        gon.fzcfche = @fzcfche
        @fzcjche = { name: '非正常接车办理科目', value: m['非正常接车办理科目'] }
        gon.fzcjche = @fzcjche
    end

    def reason_hot_all
        # m = TReasonInfo.joins(:t_detail_reason_infoes).group(:F_name).size.sort { |a, b| b[1] <=> a[1] }
        m = TReasonInfo.joins(:t_detail_reason_infoes).group(:F_name).size.sort_by { |_key, value| value }.reverse.first(4).to_h
        @fl = { name: '车机联控用语不标准', value: m['车机联控用语不标准'] }
        gon.fl = @fl
        @dc = { name: '未核对阶段计划', value: m['未核对阶段计划'] }
        gon.dc = @dc
        @wt = { name: '未通知有关人员', value: m['未通知有关人员'] }
        gon.wt = @wt
        @wz = { name: '未检查设备备品', value: m['未检查设备备品'] }
        gon.wz = @wz
    end
end
