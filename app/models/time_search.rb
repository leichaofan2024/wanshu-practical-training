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

    def scope_student_wk
        TUserInfo.where(F_type: 0).joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_ck
        TUserInfo.where(F_type: 0).joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    private

    def parsed_date(date_string, default)
        Date.parse(date_string)
      rescue ArgumentError, TypeError
          default
      end
end
