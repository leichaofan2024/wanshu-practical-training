class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :authenticate_user!
    helper_method [:duan, :duan_z, :duan_cw, :duan_ju, :duan_ck_count, :station, :station_ck_count, :team, :team_ju, :team_ck_count, :student_wk_count, :students, :student_ck_count, :student_ck_counts, :teacher, :program_ck_count,
                   :score_90, :score_80, :score_60, :score_60_below, :program_type_percent, :reason_hot_all]

    def duan
        m = TDuanInfo.where.not('F_name= ? || F_name= ?', '局职教基地', '运输处').count
    end

# 这个是第一个卡片
    def duan_ck_count
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_duan.select('t_duan_info.F_uuid').distinct.count
        else
            m = TDuanInfo.duan_orgnization.joins(t_user_infoes: :t_record_infoes).where('t_user_info.F_type = ?', 0).datetime.select('t_duan_info.F_uuid').distinct.count
      end
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
      if current_user.permission == 1
        m = TStationInfo.where.not('F_duan_uuid = ? || F_duan_uuid = ? ', duan_ju.first.F_uuid, duan_ju.last.F_uuid).count
      elsif current_user.permission == 2
        m= TStationInfo.where(F_duan_uuid: TDuanInfo.find_by(:F_name => current_user.orgnize).F_uuid).count
      end

    end

    def station_ju
        m = TStationInfo.includes(:t_record_infoes).where('F_duan_uuid = ? || F_duan_uuid = ? ', duan_ju.first.F_uuid, duan_ju.last.F_uuid)
    end
# 这是第二个卡片
    def station_ck_count
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_station.distinct.count
        else
            m = TStationInfo.joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', Date.today.beginning_of_month, Date.today.end_of_month).distinct.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_station.joins(:t_duan_info).where("t_duan_info.F_name=?", current_user.orgnize).distinct.count
        else
            m = TStationInfo.joins(:t_duan_info,t_user_infoes: :t_record_infoes).where("t_duan_info.F_name=?", current_user.orgnize).datetime.distinct.count
        end
      end
    end

    def team
      if current_user.permission == 1
        m = TDuanInfo.where.not(F_name: %w(运输处 局职教基地)).joins(t_station_infoes: :t_team_infoes).count
      elsif current_user.permission == 2
        m = TTeamInfo.joins(t_station_info: :t_duan_info).where("t_duan_info.F_name= ?",current_user.orgnize).count
      elsif current_user.permission ==3
        m = TTeamInfo.joins(:t_station_info).where("t_station_info.F_name": current_user.orgnize).count
      end

    end
# 这是第三个卡片
    def team_ck_count
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_team.distinct.count
        else
            m = TTeamInfo.joins(t_station_info: :t_duan_info).where.not("t_duan_info.F_name = '运输处' OR t_duan_info.F_name = '局职教基地'").datetime.joins(:t_record_infoes).distinct.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_team_duan(current_user.orgnize).distinct.count
        else
            m = TTeamInfo.joins(t_station_info: :t_duan_info).where("t_duan_info.F_name= ?",current_user.orgnize).joins(:t_record_infoes).datetime.distinct.count
        end
      elsif current_user.permission ==3
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m= @search.scope_team_station(current_user.orgnize).distinct.count
        else
          m = TTeamInfo.joins(:t_station_info,{t_user_infoes: :t_record_infoes}).where("t_station_info.F_name": current_user.orgnize,"t_user_info.F_uuid": TUserInfo.student_all.ids).distinct.count
        end
      end
    end

    def students
      if current_user.permission == 1
        m = TUserInfo.student_all.select(:F_name,:F_id).distinct.count
      elsif current_user.permission == 2
        m = TUserInfo.student_all.joins(:t_duan_info).where("t_duan_info.F_name= ?",current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count
      elsif current_user.permission == 3
        m = TUserInfo.student_all.joins(:t_station_info).where("t_station_info.F_name=?", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count
      end
    end

    def student_ck_counts
      if current_user.permission == 1
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = @search.scope_student.select("t_user_info.F_name,t_user_info.F_id").distinct.count
        else
          m = TUserInfo.student_all.joins(:t_record_infoes).select("t_user_info.F_name,t_user_info.F_id").datetime.distinct.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = @search.scope_student.joins(:t_duan_info).where("t_duan_info.F_name= ? ", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count
        else
          m = TUserInfo.where(F_type: 0).joins(:t_duan_info,:t_record_infoes).where("t_duan_info.F_name= ?", current_user.orgnize).datetime.select("t_user_info.F_name,t_user_info.F_id").distinct.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = @search.scope_student.joins(:t_station_info).where("t_station_info.F_name= ? ", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count
        else
          m = TUserInfo.where(F_type: 0).joins(:t_station_info,:t_record_infoes).where("t_station_info.F_name= ?", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count
        end
      end
    end

    def student_wk_count
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = TUserInfo.where(F_type: 0).select("t_user_info.F_name,t_user_info.F_id").distinct.count - @search.scope_student_k.select("t_user_info.F_name,t_user_info.F_id").distinct.count
        else
            m = TUserInfo.where(F_type: 0).select("t_user_info.F_name,t_user_info.F_id").distinct.count - TUserInfo.where(F_type: 0).joins(:t_record_infoes).datetime.select("t_user_info.F_name,t_user_info.F_id").distinct.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = TUserInfo.student_all.joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count - @search.scope_student_k.joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count
        else
            m = TUserInfo.student_all.joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count - TUserInfo.where(F_type: 0).joins(:t_duan_info,:t_record_infoes).datetime.where("t_duan_info.F_name= ?", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = TUserInfo.student_all.joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count - @search.scope_student_k.joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count
        else
            m = TUserInfo.student_all.joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count - TUserInfo.where(F_type: 0).joins(:t_station_info,:t_record_infoes).where("t_station_info.F_name= ?", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count
        end
      end
      s = {}
      s['未考人数'] = m
      @weikao = { name: '未考人数', value: s['未考人数'] }
      gon.weikao = @weikao
    end

    def student_ck_count
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_student_k.select("t_user_info.F_name,t_user_info.F_id").distinct.count
        else
            m = TUserInfo.where(F_type: 0).joins(:t_record_infoes).datetime.select("t_user_info.F_name,t_user_info.F_id").distinct.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = @search.scope_student_k.joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count
        else
          m = TUserInfo.where(F_type: 0).joins(:t_duan_info,:t_record_infoes).datetime.where("t_duan_info.F_name= ?", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = @search.scope_student_k.joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count
        else
          m = TUserInfo.where(F_type: 0).joins(:t_station_info,:t_record_infoes).where("t_station_info.F_name= ?", current_user.orgnize).select("t_user_info.F_name,t_user_info.F_id").distinct.count
        end
      end
        result = {}
        result['实考人数'] = m
        @shikao = { name: '实考人数', value: result['实考人数'] }
        gon.shikao = @shikao
    end

    def teacher
        m = TUserInfo.where(F_type: 1)
    end

    def program_ck_count
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_program
        else
            m = TProgramInfo.joins(:t_record_infoes).datetime.distinct.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = @search.scope_program_duan.where("t_duan_info.F_name= ?", current_user.orgnize).distinct.count
        else
          m = TProgramInfo.joins(t_record_infoes: :t_duan_info).datetime.where("t_duan_info.F_name= ?", current_user.orgnize).distinct.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = @search.scope_program_station.where("t_station_info.F_name= ?", current_user.orgnize).distinct.count
        else
          m = TProgramInfo.joins(t_record_infoes: :t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).distinct.count
        end
      end
    end

    def score_90
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ?', 90).count
        else
            m = TRecordInfo.where('F_score >= ?', 90).datetime.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ?', 90).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score >= ?', 90).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).datetime.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ?', 90).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score >= ?', 90).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).count
        end
      end
        result = {}
        result['90分以上'] = m
        @nine = { name: '90分以上', value: result['90分以上'] }
        gon.nine = @nine
    end

    def score_80
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ? AND F_score<? ', 80, 90).count
        else
            m = TRecordInfo.where('F_score >= ? AND F_score<? ', 80, 90).datetime.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ? AND F_score<? ', 80, 90).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score >= ? AND F_score<? ', 80, 90).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).datetime.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ? AND F_score<? ', 80, 90).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score >= ? AND F_score<? ', 80, 90).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).count
        end
      end
        result = {}
        result['80分-90分'] = m
        @eight = { name: '80分-90分', value: result['80分-90分'] }
        gon.eight = @eight
    end

    def score_60
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ? AND F_score<? ', 60, 80).count
        else
            m = TRecordInfo.where('F_score >= ? AND F_score<? ', 60, 80).datetime.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ? AND F_score<? ', 60, 80).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score >= ? AND F_score<? ', 60, 80).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).datetime.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ? AND F_score<? ', 60, 80).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score >= ? AND F_score<? ', 60, 80).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).count
        end
      end

        result = {}
        result['60分-80分'] = m
        @six = { name: '60分-80分', value: result['60分-80分'] }
        gon.six = @six
    end

    def score_60_below
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score< ? ', 60).count
        else
            m = TRecordInfo.where('F_score< ? ', 60).datetime.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score< ? ', 60).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score< ? ', 60).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).datetime.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score< ? ', 60).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score< ? ', 60).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).count
        end
      end
        result = {}
        result['60分以下'] = m
        @below = { name: '60分以下', value: result['60分以下'] }
        gon.below = @below
    end

    def program_type_percent
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_program_type
        else
            m = TProgramTypeInfo.joins(t_program_infoes: :t_record_infoes).datetime.group(:F_name).count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_program_type_duan.where("t_duan_info.F_name= ?", current_user.orgnize).group(:F_name).count
        else
            m = TProgramTypeInfo.joins(t_program_infoes: {t_record_infoes: :t_duan_info}).where("t_duan_info.F_name=?", current_user.orgnize).datetime.group("t_program_type_info.F_name").count
        end
      elsif current_user.permission == 3
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_program_type_station.where("t_station_info.F_name= ?", current_user.orgnize).group(:F_name).count
        else
            m = TProgramTypeInfo.joins(t_program_infoes: {t_record_infoes: :t_station_info}).where("t_station_info.F_name=?", current_user.orgnize).group("t_program_type_info.F_name").count
        end
      end

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
      if current_user.permission == 1
        if params[:search].present?
            # m = TReasonInfo.joins(:t_detail_reason_infoes).group(:F_name).size.sort { |a, b| b[1] <=> a[1] }
            @search = TimeSearch.new(params[:search])
            m = @search.scope_reason_hot.group(:F_name).size.sort_by { |_key, value| value }.reverse.first(4).to_h
        else
            m = TReasonInfo.joins(:t_detail_reason_infoes).datetime1.group(:F_name).size.sort_by { |_key, value| value }.reverse.first(4).to_h
        end
      elsif current_user.permission == 2
        record = TRecordDetailInfo.joins(t_record_info: :t_duan_info).where("t_duan_info.F_name=?", current_user.orgnize)
        if params[:search].present?
          # m = TReasonInfo.joins(:t_detail_reason_infoes).group(:F_name).size.sort { |a, b| b[1] <=> a[1] }
          @search = TimeSearch.new(params[:search])
          m = @search.scope_reason_hot1(current_user.orgnize).group("t_reason_info.F_name").count.sort_by { |_key, value| value }.reverse.first(4).to_h
        else
          m = TReasonInfo.joins(:t_record_detail_infoes).where("t_record_detail_info.F_uuid": record.ids).datetime1.group("t_reason_info.F_name").count.sort_by { |_key, value| value }.reverse.first(4).to_h
        end
      elsif current_user.permission == 3
        record = TRecordDetailInfo.joins(t_record_info: :t_station_info).where("t_station_info.F_name=?", current_user.orgnize)
        if params[:search].present?
          # m = TReasonInfo.joins(:t_detail_reason_infoes).group(:F_name).size.sort { |a, b| b[1] <=> a[1] }
          @search = TimeSearch.new(params[:search])
          m = @search.scope_reason_hot2(current_user.orgnize).group("t_reason_info.F_name").count.sort_by { |_key, value| value }.reverse.first(4).to_h
        else
          m = TReasonInfo.joins(:t_record_detail_infoes).where("t_record_detail_info.F_uuid": record.ids).group("t_reason_info.F_name").count.sort_by { |_key, value| value }.reverse.first(4).to_h
        end
      end
        a,b,c,d = m.keys
        gon.a = a
        gon.b = b
        gon.c = c
        gon.d = d
        @fl = { name: a, value: m[a] }
        gon.fl = @fl
        @dc = { name: b, value: m[b] }
        gon.dc = @dc
        @wt = { name: c, value: m[c] }
        gon.wt = @wt
        @wz = { name: d, value: m[d] }
        gon.wz = @wz
    end
end
