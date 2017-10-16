class TimeSearch
    attr_reader :date_from, :date_to

    def initialize(params)
        params ||= {}
        @date_from = parsed_date(params[:date_from], Date.today.beginning_of_month.to_s)
        @date_to = parsed_date(params[:date_to], Date.today.to_s)
    end

    def scope_student
        TUserInfo.where(F_type: 0).joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan
        TDuanInfo.duan_orgnization.joins(t_user_infoes: :t_record_infoes).where('t_user_info.F_type = ?', 0).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_station
        TStationInfo.joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team
        TTeamInfo.joins(t_station_info: :t_duan_info).where.not("t_duan_info.F_name = '运输处' OR t_duan_info.F_name = '局职教基地'").joins(t_user_infoes: :t_record_infoes).where("t_user_info.F_uuid": TUserInfo.student_all.ids).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team_duan
        TTeamInfo.joins(t_station_info: :t_duan_info).where.not('t_duan_info.F_name = ?', current_user.orgnize).joins(t_user_infoes: :t_record_infoes).where("t_user_info.F_uuid": TUserInfo.student_all.ids).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team_station
      TTeamInfo.joins(:t_station_info,{t_user_infoes: :t_record_infoes}).where("t_station_info.F_name": current_user.orgnize,"t_user_info.F_uuid": TUserInfo.student_all.ids).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_k
        TUserInfo.where(F_type: 0).joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program
        TProgramInfo.joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).distinct.count
    end

    def scope_program_duan
        TProgramInfo.joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ? ', @date_from, @date_to)
    end

    def scope_score
        TRecordInfo.where('F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_type
        TProgramTypeInfo.joins(t_program_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).group(:F_name).count
    end

    def scope_program_type_duan
        TProgramTypeInfo.joins(t_program_infoes: { t_record_infoes: :t_duan_info }).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_type_station
        TProgramTypeInfo.joins(t_program_infoes: { t_record_infoes: :t_station_info }).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_reason_hot
        TReasonInfo.joins(:t_detail_reason_infoes).where('F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_student
      TUserInfo.where(F_type: 0).joins(:t_duan_info, :t_record_infoes).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_info(params)
      TUserInfo.student_all.joins(:t_station_info, :t_record_infoes).where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params).F_uuid).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team_student(params)
      TUserInfo.student_all.joins(:t_team_info, :t_record_infoes).where('t_team_info.F_station_uuid = ?', TStationInfo.find_by(F_name: params).F_uuid).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)

    end

    def scope_team_student2(params)
        TUserInfo.student_all.joins(:t_team_info, :t_record_infoes).where('t_team_info.F_uuid = ? AND t_record_info.F_time BETWEEN ? AND ?', params.F_uuid, @date_from, @date_to)
    end

    def scope_team_student3(params)
      TUserInfo.student_all.joins(:t_station_info, :t_record_infoes).where('t_station_info.F_uuid': params.F_uuid).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_reason
      TReasonInfo.joins(:t_detail_reason_infoes).where('F_time BETWEEN ? AND ?', @date_from, @date_to).group('t_reason_info.F_name').distinct
    end

    def scope_duan_reason1(params)
      TDetailReasonInfo.joins(:t_reason_info,t_record_detail_info: {t_record_info: :t_duan_info}).where('t_duan_info.F_name = ?',params).where('t_detail_reason_info.F_time BETWEEN ? AND ?', @date_from, @date_to).group('t_reason_info.F_name').distinct
    end

    def scope_duan_reason2(params)
      TDetailReasonInfo.joins(:t_reason_info,t_record_detail_info: {t_record_info: :t_station_info}).where('t_station_info.F_name = ?',params).where('t_detail_reason_info.F_time BETWEEN ? AND ?', @date_from, @date_to).group('t_reason_info.F_name').distinct
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

    def scope_team_score(params)
        TTeamInfo.where('t_team_info.F_station_uuid = ?', TStationInfo.find_by(F_name: params).F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_reason_student(params)
        TRecordInfo.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).joins(t_record_detail_infoes: { t_detail_reason_infoes: :t_reason_info }).where('t_reason_info.F_name = ?', params)
    end

    def scope_student_score(user_id, user_name)
        TRecordInfo.where(F_user_uuid: TUserInfo.where(F_name: user_name, F_id: user_id).ids).where('F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_cw_ck
      TDuanInfo.where.not("t_duan_info.F_name = ? OR t_duan_info.F_name = ?", "运输处","局职教基地").where(:F_type => 1).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_zhi_ck
      TDuanInfo.where.not("t_duan_info.F_name = ? OR t_duan_info.F_name = ?", "运输处","局职教基地").where(:F_type => 2).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_station_ck
      TStationInfo.where.not("t_station_info.F_duan_uuid = ? OR t_station_info.F_duan_uuid=?",TDuanInfo.find_by(:F_name => "运输处").F_uuid, TDuanInfo.find_by(:F_name => "局职教基地").F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_station1_ck
      TStationInfo.where(:F_duan_uuid => TDuanInfo.find_by(:F_name => current_user.orgnize).F_uuid ).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team_ck
      TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name != '运输处' AND t_duan_info.F_name != '局职教基地'").where("t_user_info.F_type": 0).distinct.joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team_duan_ck
      TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name=?",params[:duan_name]).where("t_user_info.F_type": 0).distinct.joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_duan_ck
      TUserInfo.student_all.joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_duan_ck2
      TUserInfo.joins(:t_duan_info).where("t_duan_info.F_name": current_user.orgnize).student_all.joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_ck
      TUserInfo.student_all.joins(:t_team_info, :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    private

    def parsed_date(date_string, default)
        Date.parse(date_string)
      rescue ArgumentError, TypeError
        default
    end
end
