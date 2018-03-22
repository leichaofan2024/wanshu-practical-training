class TimeSearch
    attr_reader :date_from, :date_to

    def initialize(params)
        if params[:date_from].blank? && params[:date_to].present?
          params[:date_from] = params[:date_to].to_time.beginning_of_month.to_s
        elsif params[:date_from].blank? && params[:date_to].blank?
          params[:date_from] = Time.now.beginning_of_month.to_s
          params[:date_to] = Time.now.end_of_month.to_s
        elsif params[:date_from].present? && params[:date_to].blank?
          params[:date_to] = params[:date_from].to_time.end_of_month.to_s
        end
        @time_from = parsed_date(params[:date_from]).beginning_of_day
        @time_to = parsed_date(params[:date_to]).end_of_day
        @date_from = parsed_date(params[:date_from]).beginning_of_day+8.hours
        @date_to = parsed_date(params[:date_to]).end_of_day+8.hours
    end

    def scope_student
      TUserInfo.student_all(@time_from,@time_to).where.not(F_duan_uuid: ["74708afh145a11e6ad9d001ec9b3cd0c", "74708bnv145a11e6ad9d001ec9b3cd0c"]).joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_student_ck(params)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_record_infoes).program_record(params).where("t_record_info.F_time BETWEEN ? AND ?", @date_from , @date_to)
    end

    def scope_duan
      TDuanInfo.duan_orgnization.joins(t_user_infoes: :t_record_infoes).student_all(@time_from,@time_to).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_duan_ck(params)
      TDuanInfo.duan_orgnization.joins(t_user_infoes: :t_record_infoes).student_all(@time_from,@time_to).program_record(params).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_station
      TStationInfo.station_orgnization.joins(t_user_infoes: :t_record_infoes).student_all(@time_from,@time_to).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team
      TTeamInfo.team_orgnization.joins(t_user_infoes: :t_record_infoes).student_all(@time_from,@time_to).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_team_ck(params)
      TTeamInfo.team_orgnization.joins(t_user_infoes: :t_record_infoes).student_all(@time_from,@time_to).program_record(params).where("t_record_info.F_time BETWEEN ? AND ? ",@date_from, @date_to)
    end

    def scope_team_duan(params)
        TTeamInfo.joins(t_station_info: :t_duan_info).where('t_duan_info.F_name = ?', params).joins(t_user_infoes: :t_record_infoes).student_all(@time_from,@time_to).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team_station(params)
      TTeamInfo.joins(:t_station_info,t_user_infoes: :t_record_infoes).where("t_station_info.F_name": params).student_all(@time_from,@time_to).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_k
        TUserInfo.student_all(@time_from,@time_to).where.not(F_duan_uuid: ["74708afh145a11e6ad9d001ec9b3cd0c", "74708bnv145a11e6ad9d001ec9b3cd0c"]).joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_dabiao1
      TUserInfo.student_all(@time_from,@time_to).where.not(F_duan_uuid: ["74708afh145a11e6ad9d001ec9b3cd0c", "74708bnv145a11e6ad9d001ec9b3cd0c"]).joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).group("t_user_info.F_id").sum("t_record_info.time_length")
    end

    def scope_student_dabiao2(params)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_record_infoes,:t_duan_info).where("t_duan_info.F_name": params.orgnize).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).group("t_user_info.F_id").sum("t_record_info.time_length")
    end

    def scope_student_dabiao3(params)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_record_infoes,:t_station_info).where("t_station_info.F_name": params.orgnize).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).group("t_user_info.F_id").sum("t_record_info.time_length")
    end

    def scope_program
        TProgramInfo.joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).distinct.count
    end

    def scope_program_duan
        TProgramInfo.joins(t_record_infoes: :t_duan_info).where('t_record_info.F_time BETWEEN ? AND ? ', @date_from, @date_to)
    end

    def scope_program_station
        TProgramInfo.joins(t_record_infoes: :t_station_info).where('t_record_info.F_time BETWEEN ? AND ? ', @date_from, @date_to)
    end

    def scope_score
      TRecordInfo.where('F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_score(params)
      TRecordInfo.program_record(params).where("F_time BETWEEN ? AND ? ", @date_from, @date_to)
    end

    def scope_program_type
        TProgramTypeInfo.joins(t_program_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).group(:F_name).count
    end

    def scope_program_type_duan
        TProgramTypeInfo.joins(t_program_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_type_station
        TProgramTypeInfo.joins(t_program_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_reason_hot
      TReasonInfo.joins(:t_detail_reason_infoes).where('F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_reason_hot(params)
      TReasonInfo.joins(t_detail_reason_infoes: :t_record_detail_info).where("t_record_detail_info.F_program_id": TProgramInfo.find_by(:F_name => params).F_id).where('t_detail_reason_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_reason_hot1(params)
        record = TRecordDetailInfo.joins(t_record_info: :t_duan_info).where("t_duan_info.F_name=?", params)
        TReasonInfo.joins(:t_record_detail_infoes).where("t_record_detail_info.F_uuid": record.ids).where('F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_reason_hot2(params)
      record = TRecordDetailInfo.joins(t_record_info: :t_station_info).where("t_station_info.F_name=?", params)
      TReasonInfo.joins(:t_record_detail_infoes).where("t_record_detail_info.F_uuid": record.ids)
    end


    def scope_duan_student
      TUserInfo.student_all(@time_from,@time_to).joins(:t_duan_info, :t_record_infoes).duan_orgnization.where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_cw_dabiao
      TUserInfo.student_all(@time_from,@time_to).joins(:t_duan_info, :t_record_infoes).duan_orgnization.where('t_duan_info.F_type= ?', 1).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).group("t_user_info.F_id").sum("t_record_info.time_length")
    end

    def scope_duan_zs_dabiao
      TUserInfo.student_all(@time_from,@time_to).joins(:t_duan_info, :t_record_infoes).duan_orgnization.where('t_duan_info.F_type= ?', 2).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).group("t_user_info.F_id").sum("t_record_info.time_length")
    end

    def scope_program_duan_student(params)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_duan_info, :t_record_infoes).duan_orgnization.program_record(params).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_info(params)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_station_info, :t_record_infoes).where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params).F_uuid).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_dabiao_info(params)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_station_info, :t_record_infoes).where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params).F_uuid).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).group("t_user_info.F_id").sum("t_record_info.time_length")
    end

    def scope_program_student_info(params,params1)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_station_info, :t_record_infoes).program_record(params1).where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params).F_uuid).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team_student(params)
      params.joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_team_student(params,params1)
      params.joins(:t_record_infoes).program_record(params1).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team_student2(params)
      params.joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end



    def scope_program_team_student2(params,params1)
      params.joins(:t_record_infoes).program_record(params1).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team_student3(params)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_station_info, :t_record_infoes).where('t_station_info.F_uuid': params.F_uuid).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_team_student3(params,params1)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_station_info, :t_record_infoes).program_record(params1).where('t_station_info.F_uuid': params.F_uuid).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_reason
      TDetailReasonInfo.joins(:t_reason_info).where('F_time BETWEEN ? AND ?', @date_from, @date_to).group('t_reason_info.F_name').distinct
    end

    def scope_program_duan_reason(params)
      TDetailReasonInfo.program_detail_reason(params).joins(:t_reason_info).where('F_time BETWEEN ? AND ?', @date_from, @date_to).group('t_reason_info.F_name').distinct
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

    def scope_program_duan_score1(params)
      TDuanInfo.where('t_duan_info.F_type= ?', 1).joins(t_user_infoes: :t_record_infoes).program_record(params).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_score2
      TDuanInfo.where('t_duan_info.F_type= ?', 2).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_duan_score2(params)
      TDuanInfo.where('t_duan_info.F_type= ?', 2).joins(t_user_infoes: :t_record_infoes).program_record(params).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_station_score(params)
      TStationInfo.where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params).F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_station_score(params,params1)
      TStationInfo.where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params).F_uuid).joins(t_user_infoes: :t_record_infoes).program_record(params1).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team_score(params)
        TTeamInfo.where('t_team_info.F_station_uuid = ?', params.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_reason_student(params)
        TRecordInfo.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).joins(t_record_detail_infoes: { t_detail_reason_infoes: :t_reason_info }).where('t_reason_info.F_name = ?', params)
    end

    def scope_program_duan_reason_student(params,params1)
      TRecordInfo.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).joins(t_record_detail_infoes: { t_detail_reason_infoes: :t_reason_info }).program_detail_reason(params1).where('t_reason_info.F_name = ?', params)
    end

    def scope_duan_reason_student1(params)
        TRecordInfo.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).joins(t_record_detail_infoes: { t_detail_reason_infoes: :t_reason_info }).where('t_reason_info.F_name = ?', params).where("t_record_info.t_duan_uuid": TDuanInfo.find_by(:F_name => params).F_uuid)
    end

    def scope_duan_reason_student2(params)
        TRecordInfo.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).joins(t_record_detail_infoes: { t_detail_reason_infoes: :t_reason_info }).where('t_reason_info.F_name = ?', params).where("t_record_info.t_station_uuid": TStationInfo.find_by(:F_name => params).F_uuid)
    end

    def scope_student_score(user_id)
        TRecordInfo.where(F_user_uuid: TUserInfo.where(F_id: user_id).ids).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_student_score(user_id,params)
      TRecordInfo.program_record(params).where(F_user_uuid: TUserInfo.where(F_id: user_id).ids).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_cw_ck
      TDuanInfo.duan_orgnization.where(:F_type => 1).joins(t_user_infoes: :t_record_infoes).student_all(@time_from,@time_to).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_duan_cw_ck(params)
      TDuanInfo.duan_orgnization.where(:F_type => 1).joins(t_user_infoes: :t_record_infoes).student_all(@time_from,@time_to).program_record(params).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_zhi_ck
      TDuanInfo.duan_orgnization.where(:F_type => 2).joins(t_user_infoes: :t_record_infoes).student_all(@time_from,@time_to).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_duan_zhi_ck(params)
      TDuanInfo.duan_orgnization.where(:F_type => 2).joins(t_user_infoes: :t_record_infoes).student_all(@time_from,@time_to).program_record(params).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_station_ck
      TStationInfo.station_orgnization.joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_station_ck(params)
      TStationInfo.station_orgnization.joins(t_user_infoes: :t_record_infoes).student_all(@time_from,@time_to).program_record(params).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_station1_ck
      TStationInfo.where(:F_duan_uuid => TDuanInfo.find_by(:F_name => current_user.orgnize).F_uuid ).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team_ck
      TTeamInfo.joins(t_station_info: :t_duan_info).duan_orgnization.joins(t_user_infoes: :t_record_infoes).student_all(@time_from,@time_to).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_team_ck(params)
      TTeamInfo.joins(t_station_info: :t_duan_info).duan_orgnization.joins(t_user_infoes: :t_record_infoes).student_all(@time_from,@time_to).program_record(params).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team_ck1(params)
      TTeamInfo.joins(t_station_info: :t_duan_info).where("t_duan_info.F_name=?",params).joins(t_user_infoes: :t_record_infoes).student_all(@time_from,@time_to).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_team_ck1(params)
      TTeamInfo.joins(t_station_info: :t_duan_info).where("t_duan_info.F_name=?",params).joins(t_user_infoes: :t_record_infoes).program_record(params1).student_all(@time_from,@time_to).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team_ck2(params)
      TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name = ?",params).student_all(@time_from,@time_to).distinct.joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_team_ck3(params)
      TTeamInfo.joins(:t_station_info,:t_user_infoes).where("t_station_info.F_name": params).student_all(@time_from,@time_to).distinct.joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_duan_ck
      TUserInfo.student_all(@time_from,@time_to).joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_student_duan_ck(params)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_record_infoes).program_record(params).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_duan_ck1(params)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_record_infoes,:t_duan_info).where("t_duan_info.F_name": params).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_student_duan_ck1(params,params1)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_record_infoes).program_record(params1).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).distinct.joins(t_duan_info: :t_station_infoes).where("t_duan_info.F_name": params)
    end

    def scope_student_duan_ck2(params)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_duan_info,:t_record_infoes).where("t_duan_info.F_name": params).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_duan_ck3(params)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_duan_info,:t_record_infoes).where("t_duan_info.F_name": params).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_duan_ck4(params)
      params.joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to).distinct.pluck(:F_id).uniq
    end

    def scope_program_ck(params)
      TProgramInfo.where("t_program_info.F_type_id": TProgramTypeInfo.find_by(:F_name => params).F_id).joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_ck1(params)
      TProgramInfo.where("t_program_info.F_type_id": TProgramTypeInfo.find_by(:F_name => params).F_id).joins(t_record_infoes: :t_duan_info).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_program_ck2(params)
      TProgramInfo.where("t_program_info.F_type_id": TProgramTypeInfo.find_by(:F_name => params).F_id).joins(t_record_infoes: :t_station_info).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_program
      TProgramInfo.joins(:t_record_infoes).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_program1(params)
      TProgramInfo.joins(t_record_infoes: :t_duan_info ).where('t_duan_info.F_name = ?', params).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_program2
      TProgramInfo.joins(t_record_infoes: :t_station_info ).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_duan_program_student
      TRecordInfo.where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_ck(params)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_team_info, :t_record_infoes).where('t_team_info.F_uuid =? ', params.F_uuid).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_student_ck1(params)
      TUserInfo.student_all(@time_from,@time_to).joins(:t_station_info, :t_record_infoes).where('t_station_info.F_uuid = ? ', params.F_uuid).where('t_record_info.F_time BETWEEN ? AND ?', @date_from, @date_to)
    end

    def scope_station_cankao
      TStationInfo.joins(:t_duan_info,{t_user_infoes: :t_record_infoes}).duan_orgnization.student_all(@time_from,@time_to).where("t_record_info.F_time BETWEEN ? AND ?", @date_from, @date_to).select("t_duan_info.F_name,t_station_info.F_uuid").distinct.group("t_duan_info.F_name").count
    end

    def scope_student_cankao
      TUserInfo.student_all(@time_from,@time_to).joins(:t_duan_info,:t_record_infoes).duan_orgnization.where("t_record_info.F_time BETWEEN ? AND ?", @date_from, @date_to).select("t_duan_info.F_name, t_user_info.F_id").distinct.group("t_duan_info.F_name").count
    end

    def scope_bg_student_dabiao
      TUserInfo.student_all(@time_from,@time_to).joins(:t_duan_info,:t_record_infoes).duan_orgnization.where("t_record_info.F_time BETWEEN ? AND ?", @date_from, @date_to).group("t_user_info.F_id").sum("t_record_info.time_length")
    end
    private

    def parsed_date(date_string)
        Date.parse(date_string)
      rescue ArgumentError, TypeError
        default
    end
end
