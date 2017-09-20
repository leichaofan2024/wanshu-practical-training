class TimeSearch
    attr_reader :date_to, :date_from

    def initialize(params)
        params ||= {}
        @date_from = parsed_date(params[:date_from], 7.days.ago.to_date.to_s)
        @date_to = parsed_date(params[:date_to], Date.today.to_s)
    end

    def scope_student
        TUserInfo.where(F_type: 0).joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan
        TDuanInfo.duan_orgnization.joins(t_user_infoes: :t_record_infoes).where('t_user_info.F_type = ?', 0).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_station
        TStationInfo.joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team
        TTeamInfo.joins(t_station_info: :t_duan_info).where.not("t_duan_info.F_name = '运输处' OR t_duan_info.F_name = '局职教基地'").joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_k
        TUserInfo.where(F_type: 0).joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program
        TProgramInfo.joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).distinct.count
    end

    def scope_score
        TRecordInfo.where('F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_type
        TProgramTypeInfo.joins(t_program_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).group(:F_name).size
    end

    def scope_reason_hot
        TReasonInfo.joins(:t_detail_reason_infoes).where('F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_student
        TUserInfo.where(F_type: 0).joins(:t_duan_info, :t_record_infoes).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_info(params)
        TUserInfo.student_all.joins(:t_station_info, :t_record_infoes).where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params).F_uuid).where('F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team_student(params)
        TUserInfo.student_all.joins(:t_team_info, :t_record_infoes).where('t_team_info.F_station_uuid = ?', TStationInfo.find_by(F_name: params).F_uuid).where('F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_reason
        TReasonInfo.joins(:t_detail_reason_infoes).where('F_time BETWEEN ? AND ?', @date_from, @date_to).group('t_reason_info.F_name')
    end

    def scope_duan_score1
        TDuanInfo.where('t_duan_info.F_type= ?', 1).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_score2
        TDuanInfo.where('t_duan_info.F_type= ?', 2).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_station_score(params)
        TStationInfo.where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params).F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    private

    def parsed_date(date_string, default)
        Date.parse(date_string)
      rescue ArgumentError, TypeError
          default
      end
end
