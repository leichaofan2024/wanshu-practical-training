class TProgramInfoesController < ApplicationController

  def show
    if params[:F_name].present?
      @t_program_info = TProgramInfo.program(params[:name])
      @t_record_infoes = TRecordInfo.program_record(params[:name])
    end

    @duan_sum = TDuanInfo.where.not('F_name= ? || F_name= ?', '局职教基地', '运输处').count
    @station_sum = TStationInfo.station_orgnization.joins(:t_user_infoes).student_all.distinct.count
    @team_sum = TTeamInfo.team_orgnization.joins(:t_user_infoes).student_all.distinct.count
    @student_sum = TUserInfo.student_all.distinct.count

     # 五张卡片及饼图数据：
    if params[:search].present?
        @search = TimeSearch.new(params[:search])
        @duan_ck_count = @search.scope_program_duan_ck(params[:name]).select('t_duan_info.F_uuid').distinct.count
        @station_ck_count = @search.scope_program_station_ck(params[:name]).distinct.count
        @team_ck_count = @search.scope_program_team_ck(params[:name]).distinct.count
        @student_ck_count = @search.scope_program_student_ck(params[:name]).distinct.count
        @score_90 = @search.scope_program_score(params[:name]).where('F_score >= ?', 90).count
        @score_80 = @search.scope_program_score(params[:name]).where('F_score >= ? AND F_score < ?', 80, 90).count
        @score_60 = @search.scope_program_score(params[:name]).where('F_score >= ? AND F_score < ?', 60,80).count
        @score_60_below = @search.scope_program_score(params[:name]).where('F_score < ?', 60).count
        @reason_hot_all = @search.scope_program_reason_hot(params[:name]).group(:F_name).size.sort_by { |_key, value| value }.reverse.first(8).to_h
    else
        @duan_ck_count = TDuanInfo.duan_orgnization.joins(t_user_infoes: :t_record_infoes).student_all.program_record(params[:name]).datetime.select('t_duan_info.F_uuid').distinct.count
        @station_ck_count = TStationInfo.joins(t_user_infoes: :t_record_infoes).program_record(params[:name]).datetime.distinct.count
        @team_ck_count = TTeamInfo.team_orgnization.joins(t_user_infoes: :t_record_infoes).student_all.program_record(params).datetime.distinct.count
        @student_ck_count = TUserInfo.student_all.joins(:t_record_infoes).program_record(params[:name]).datetime.distinct.count
        @score_90 = TRecordInfo.program_record(params[:name]).datetime.where('F_score >= ?', 90).count
        @score_80 = TRecordInfo.program_record(params[:name]).datetime.where('F_score >= ? AND F_score < ?', 80, 90).count
        @score_60 = TRecordInfo.program_record(params[:name]).datetime.where('F_score >= ? AND F_score < ?', 60, 80).count
        @score_60_below = TRecordInfo.program_record(params[:name]).datetime.where('F_score < ?', 60).count
        @reason_hot_all = TReasonInfo.joins(t_detail_reason_infoes: :t_record_detail_info).where("t_record_detail_info.F_program_id": TProgramInfo.find_by(:F_name => params[:name]).F_id).datetime1.group(:F_name).size.sort_by { |_key, value| value }.reverse.first(8).to_h
    end

    # 饼图一：
    sw = {}
    sw['未考人数'] = @student_sum - @student_ck_count
    gon.weikao = { name: '未考人数', value: sw['未考人数'] }

    ss = {}
    ss["实考人数"] = @student_ck_count
    gon.shikao = { name: "实考人数", value: ss["实考人数"]}

    # 饼图二：
    result_90 = {}
    result_90['90分以上'] = @score_90
    gon.nine = { name: '90分以上', value: result_90['90分以上'] }
    result_80 = {}
    result_80['80分-90分'] = @score_80
    gon.eight = { name: '80分-90分', value: result_80['80分-90分'] }
    result_60 = {}
    result_60['60分-80分'] = @score_60
    gon.six = { name: '60分-80分', value: result_60['60分-80分'] }
    result_60_below = {}
    result_60_below['60分以下'] = @score_60_below
    gon.below = { name: '60分以下', value: result_60_below['60分以下'] }

    # 饼图三：


    gon.reason_keys = @reason_hot_all.keys.first(8)
    @a = { name: @reason_hot_all.keys[0], value: @reason_hot_all.values[0] }
    gon.a = @a
    @b = { name: @reason_hot_all.keys[1], value: @reason_hot_all.values[1]}
    gon.b = @b
    @c = { name: @reason_hot_all.keys[2], value: @reason_hot_all.values[2] }
    gon.c = @c
    @d = { name: @reason_hot_all.keys[3], value: @reason_hot_all.values[3] }
    gon.d = @d
    @e = { name: @reason_hot_all.keys[4], value: @reason_hot_all.values[4] }
    gon.e = @e
    @f = { name: @reason_hot_all.keys[5], value: @reason_hot_all.values[5]}
    gon.f = @f
    @g = { name: @reason_hot_all.keys[6], value: @reason_hot_all.values[6] }
    gon.g = @g
    @h = { name: @reason_hot_all.keys[7], value: @reason_hot_all.values[7] }
    gon.h = @h

  end

  def program_duan_ck
    @t_program_info = TProgramInfo.find_by(:F_name => params[:name])
    duan = TDuanInfo.duan_orgnization
    cw = duan.where(:F_type => 1)
    zhi = duan.where(:F_type => 2)
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          @ck_cw = @search.scope_program_duan_cw_ck(params[:name]).distinct.group('t_duan_info.F_name').count.keys
          @ck_zhi = @search.scope_program_duan_zhi_ck(params[:name]).distinct.group("t_duan_info.F_name").count.keys
      else
        @ck_cw = cw.joins(t_user_infoes: :t_record_infoes).program_record(params[:name]).datetime.student_all.distinct.group('t_duan_info.F_name').count.keys
        @ck_zhi = zhi.joins(t_user_infoes: :t_record_infoes).program_record(params[:name]).datetime.student_all.distinct.group("t_duan_info.F_name").count.keys
      end
        @wk_cw = cw.pluck(:F_name) - @ck_cw
        @wk_zhi = zhi.pluck(:F_name) - @ck_zhi
  end

  def program_station_ck
    @t_program_info = TProgramInfo.find(params[:id])
    if params[:search].present?
      @search = TimeSearch.new(params[:search])
        station = TStationInfo.station_orgnization.joins(:t_user_infoes).student_all.distinct
        station_ck = @search.scope_program_station_ck(params[:name]).distinct
        @wk_z = station.where.not(:F_uuid => station_ck.ids)
        @ck_z = station_ck
        @ck_stations = station_ck.group_by{|u| u.F_duan_uuid}
        @wk_stations = @wk_z.group_by{|u| u.F_duan_uuid}
    else
        station = TStationInfo.station_orgnization.joins(:t_user_infoes).student_all.distinct
        station_ck = station.joins(t_user_infoes: :t_record_infoes).program_record(params[:name]).datetime.student_all.distinct
        @wk_z = station.where.not(:F_uuid => station_ck.ids)
        @ck_z = station_ck
        @ck_stations = station_ck.group_by{|u| u.F_duan_uuid}
        @wk_stations = @wk_z.group_by{|u| u.F_duan_uuid}
end
  end

  def program_team_ck
    @t_program_info = TProgramInfo.find(params[:id])
    if params[:search].present?
      @search = TimeSearch.new(params[:search])
        team = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).duan_orgnization.student_all.distinct
        teams_ck = @search.scope_program_team_ck(params[:name]).distinct
        teams_wk = team.where.not(:"t_team_info.F_uuid" => teams_ck.ids)
        @ck_z = TDuanInfo.duan_orgnization.joins(t_station_infoes: :t_team_infoes).where("t_team_info.F_uuid": teams_ck.ids)
        @wk_z = TDuanInfo.duan_orgnization.joins(t_station_infoes: :t_team_infoes).where("t_team_info.F_uuid": teams_wk.ids)
        @duans_ck = @ck_z.distinct
        @duans_wk = @wk_z .distinct


        if params[:duan_name].present?
          team_duan = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name=?",params[:duan_name]).student_all.distinct
          team_ck = @search.scope_program_team_ck1(params[:duan_name],params[:name]).student_all.distinct
          @ck_teams = team_ck.group_by{|u| u.F_station_uuid}
          @wk_teams = team_duan.where.not(:F_uuid => team_ck.ids).group_by{|u| u.F_station_uuid}
        end

    else
      team = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).duan_orgnization.student_all.distinct
      teams_ck = team.joins(t_user_infoes: :t_record_infoes).program_record(params[:name]).datetime.student_all.distinct
      teams_wk = team.where.not(:"t_team_info.F_uuid" => teams_ck.ids)
      @ck_z = TDuanInfo.duan_orgnization.joins(t_station_infoes: :t_team_infoes).where("t_team_info.F_uuid": teams_ck.ids)
      @wk_z = TDuanInfo.duan_orgnization.joins(t_station_infoes: :t_team_infoes).where("t_team_info.F_uuid": teams_wk.ids)
      @duans_ck = @ck_z.distinct
      @duans_wk = @wk_z .distinct


      if params[:duan_name].present?
        team_duan = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name=?",params[:duan_name]).student_all.distinct
        team_ck = TTeamInfo.joins(t_station_info: :t_duan_info).where("t_duan_info.F_name=?",params[:duan_name]).joins(t_user_infoes: :t_record_infoes).program_record(params[:name]).datetime.student_all.distinct
        @ck_teams = team_ck.group_by{|u| u.F_station_uuid}
        @wk_teams = team_duan.where.not(:F_uuid => team_ck.ids).group_by{|u| u.F_station_uuid}
      end

    end
  end

  def program_student_ck
    @t_program_info = TProgramInfo.find(params[:id])
    if params[:search].present?
          @search = TimeSearch.new(params[:search])
            student = TUserInfo.student_all
            students_duan_ck = @search.scope_program_student_duan_ck(params[:name]).distinct
            students_duan_wk = student.where.not("t_user_info.F_uuid": students_duan_ck.ids)
            @duans_ck = TDuanInfo.duan_orgnization.joins(:t_user_infoes).where("t_user_info.F_uuid": students_duan_ck.ids).distinct
            @duans_wk = TDuanInfo.duan_orgnization.joins(:t_user_infoes).where("t_user_info.F_uuid": students_duan_wk.ids).distinct

            if params[:duan_name].present?
              students_duan_ck = @search.scope_program_student_duan_ck1(params[:duan_name],params[:name])
              students_duan_wk = student.where.not("t_user_info.F_uuid": students_duan_ck.ids)
              @ck_students = students_duan_ck.select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_duan_uuid,t_user_info.F_station_uuid,t_user_info.F_team_uuid").distinct.group_by{|u| u.F_station_uuid}
              @wk_students = students_duan_wk.joins(t_duan_info: :t_station_infoes).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_duan_uuid,t_user_info.F_station_uuid,t_user_info.F_team_uuid").distinct.group_by{|u| u.F_station_uuid}
            end
    else
          student = TUserInfo.student_all
          students_duan_ck = student.joins(:t_record_infoes).program_record(params).datetime.distinct
          students_duan_wk = student.where.not("t_user_info.F_uuid": students_duan_ck.ids)
          @duans_ck = TDuanInfo.duan_orgnization.joins(:t_user_infoes).where("t_user_info.F_uuid": students_duan_ck.ids).distinct
          @duans_wk = TDuanInfo.duan_orgnization.joins(:t_user_infoes).where("t_user_info.F_uuid": students_duan_wk.ids).distinct
          if params[:duan_name].present?
            @ck_students = students_duan_ck.joins(t_duan_info: :t_station_infoes).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_duan_uuid,t_user_info.F_station_uuid,t_user_info.F_team_uuid").distinct.group_by{|u| u.F_station_uuid}
            @wk_students = students_duan_wk.joins(t_duan_info: :t_station_infoes).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_duan_uuid,t_user_info.F_station_uuid,t_user_info.F_team_uuid").distinct.group_by{|u| u.F_station_uuid}
          end
    end
  end


end
