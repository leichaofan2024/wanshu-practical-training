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


end
