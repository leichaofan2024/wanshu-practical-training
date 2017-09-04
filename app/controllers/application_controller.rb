class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    helper_method [:duan, :duan_z, :duan_cw, :duan_ju, :duan_ck_count, :station, :station_ck_count, :team, :team_ju, :team_ck_count, :student, :student_ck_count, :teacher, :program_ck_count,
                   :score_90, :score_80, :score_60, :score_60_below, :program_type_percent, :reason_hot_all]
    def duan
        m = TDuanInfo.where.not('F_name= ? || F_name= ?', '局职教基地', '运输处').count
    end

    def duan_ck_count
        m = TRecordInfo.select('F_duan_uuid').group('F_duan_uuid').size.count - 2
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

    def student
        m = TUserInfo.where(F_type: 0).count
        s = {}
        s['参考人数'] = m
        @cankao = { name: '参考人数', value: s['参考人数'] }
        gon.cankao = @cankao
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
        m = TReasonInfo.joins(:t_detail_reason_infoes).group(:F_name).size.sort_by { |_key, value| value }.to_h
        @fl = { name: '分路不良道岔未加锁', value: m['分路不良道岔未加锁'] }
        gon.fl = @fl
        @dc = { name: '道岔未紧固', value: m['道岔未紧固'] }
        gon.dc = @dc
        @wt = { name: '未通知电务', value: m['未通知电务'] }
        gon.wt = @wt
        @wz = { name: '未正确开放引导信号', value: m['未正确开放引导信号'] }
        gon.wz = @wz
        @flbl = { name: '分路不良未确认空闲', value: m['分路不良未确认空闲'] }
        gon.flbl = @flbl
        @wtgw = { name: '未通知工务', value: m['未通知工务'] }
        gon.wtgw = @wtgw
        @yl = { name: '漏传、错传调度命令', value: m['漏传、错传调度命令'] }
        gon.yl = @yl
        @wb = { name: '未办理闭塞（预告）', value: m['未办理闭塞（预告）'] }
        gon.wb = @wb
    end
end
