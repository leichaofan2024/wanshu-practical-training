class TProgramInfoesController < ApplicationController
  layout "program_frame"
  def show
    gon.program_id = params[:id]
    if params[:name].present?
      @t_program_info = TProgramInfo.program(params[:name])
      @t_record_infoes = TRecordInfo.program_record(params[:name])
    end

    @duan_sum = TDuanInfo.where.not('F_name= ? || F_name= ?', '局职教基地', '运输处').count
    @station_sum = TStationInfo.station_orgnization.joins(:t_user_infoes).student_all.distinct.count
    @team_sum = TTeamInfo.team_orgnization.joins(:t_user_infoes).student_all.distinct.count
    @student_sum = TUserInfo.student_all.select("t_user_info.F_id").distinct.count

     # 五张卡片及饼图数据：
    if params[:search].present?
        @search = TimeSearch.new(params[:search])
        @duan_ck_count = @search.scope_program_duan_ck(params[:name]).select('t_duan_info.F_uuid').distinct.count
        @station_ck_count = @search.scope_program_station_ck(params[:name]).distinct.count
        @team_ck_count = @search.scope_program_team_ck(params[:name]).distinct.count
        @student_ck_count = @search.scope_program_student_ck(params[:name]).select("t_user_info.F_id").distinct.count
        @score_90 = @search.scope_program_score(params[:name]).where('F_score >= ?', 90).count
        @score_80 = @search.scope_program_score(params[:name]).where('F_score >= ? AND F_score < ?', 80, 90).count
        @score_60 = @search.scope_program_score(params[:name]).where('F_score >= ? AND F_score < ?', 60,80).count
        @score_60_below = @search.scope_program_score(params[:name]).where('F_score < ?', 60).count
        n = @search.scope_program_reason_hot(params[:name]).group(:F_name).size.sort_by { |_key, value| value }.reverse

        @reason_hot_all = n.first(8).to_h
        @reason_other_value = n.to_h.values.sum - @reason_hot_all.values.sum

    else
        @duan_ck_count = TDuanInfo.duan_orgnization.joins(t_user_infoes: :t_record_infoes).student_all.program_record(params[:name]).datetime.select('t_duan_info.F_uuid').distinct.count
        @station_ck_count = TStationInfo.station_orgnization.joins(t_user_infoes: :t_record_infoes).program_record(params[:name]).datetime.distinct.count
        @team_ck_count = TTeamInfo.team_orgnization.joins(t_user_infoes: :t_record_infoes).student_all.program_record(params[:name]).datetime.distinct.count
        @student_ck_count = TUserInfo.student_all.joins(:t_record_infoes).program_record(params[:name]).datetime.select("t_user_info.F_id").distinct.count
        @score_90 = TRecordInfo.program_record(params[:name]).datetime.where('F_score >= ?', 90).count
        @score_80 = TRecordInfo.program_record(params[:name]).datetime.where('F_score >= ? AND F_score < ?', 80, 90).count
        @score_60 = TRecordInfo.program_record(params[:name]).datetime.where('F_score >= ? AND F_score < ?', 60, 80).count
        @score_60_below = TRecordInfo.program_record(params[:name]).datetime.where('F_score < ?', 60).count
        n = TReasonInfo.joins(t_detail_reason_infoes: :t_record_detail_info).where("t_record_detail_info.F_program_id": TProgramInfo.find_by(:F_name => params[:name]).F_id).datetime1.group(:F_name).size.sort_by { |_key, value| value }.reverse

        @reason_hot_all = n.first(8).to_h
        @reason_other_value = n.to_h.values.sum - @reason_hot_all.values.sum
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


    gon.reason_keys = @reason_hot_all.keys+ ["其他"]
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
    @i = { name: "其他", value: @reason_other_value }
    gon.i = @i

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
          students_duan_ck = student.joins(:t_record_infoes).program_record(params[:name]).datetime.distinct
          students_duan_wk = student.where.not("t_user_info.F_uuid": students_duan_ck.ids)
          @duans_ck = TDuanInfo.duan_orgnization.joins(:t_user_infoes).where("t_user_info.F_uuid": students_duan_ck.ids).distinct
          @duans_wk = TDuanInfo.duan_orgnization.joins(:t_user_infoes).where("t_user_info.F_uuid": students_duan_wk.ids).distinct
          if params[:duan_name].present?
            @ck_students = students_duan_ck.joins(t_duan_info: :t_station_infoes).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_duan_uuid,t_user_info.F_station_uuid,t_user_info.F_team_uuid").distinct.group_by{|u| u.F_station_uuid}
            @wk_students = students_duan_wk.joins(t_duan_info: :t_station_infoes).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_duan_uuid,t_user_info.F_station_uuid,t_user_info.F_team_uuid").distinct.group_by{|u| u.F_station_uuid}
          end
    end
  end


  def program_duan_student_info
    @t_program_info = TProgramInfo.find(params[:id])
    @duans = TDuanInfo.duan_orgnization
    @duans_student_cw = TUserInfo.student_all.joins(:t_duan_info).duan_orgnization.where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
    ncw = @duans_student_cw.keys
    vcw = @duans_student_cw.values
    @duans_student_zs = TUserInfo.student_all.joins(:t_duan_info).duan_orgnization.where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
    nzs = @duans_student_zs.keys
    vzs = @duans_student_zs.values
    if params[:search].present?
        @search = TimeSearch.new(params[:search])
        cw = @search.scope_program_duan_student(params[:name]).where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').distinct
        zs = @search.scope_program_duan_student(params[:name]).where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').distinct
        cw_ck = cw.group('t_duan_info.F_name').count
        cw_ck1 = cw_ck.keys
        @duans_student_cw_ck = []
        ncw.each do |c|
            @duans_student_cw_ck << if cw_ck1.include?(c)
                                      cw_ck[c]
                                    else
                                      0
                                    end
        end
        @duans_student_cw_ck_bl = []
        i = 0
        @duans_student_cw_ck.each do |v|
            @duans_student_cw_ck_bl << (BigDecimal(v) / BigDecimal(vcw[i])).round(3) * 100
            i += 1
        end
        cw_wk = TUserInfo.student_all.joins(:t_duan_info).duan_orgnization.where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').where.not('t_user_info.F_id' => cw.pluck('t_user_info.F_id')).distinct.group('t_duan_info.F_name').count
        cw_wk1 = cw_wk.keys
        @duans_student_cw_wk = []
        ncw.each do |c|
            @duans_student_cw_wk << if cw_wk1.include?(c)
                                        cw_wk[c]
                                    else
                                        0
                                    end
        end

        zs_ck = zs.group('t_duan_info.F_name').count
        zs_ck1 = zs_ck.keys
        @duans_student_zs_ck = []
        nzs.each do |c|
            @duans_student_zs_ck << if zs_ck1.include?(c)
                                        zs_ck[c]
                                    else
                                        0
                                    end
        end
        @duans_student_zs_ck_bl = []
        i = 0
        @duans_student_zs_ck.each do |v|
            @duans_student_zs_ck_bl << (BigDecimal(v) / BigDecimal(vzs[i])).round(3) * 100
            i += 1
        end
        zs_wk = TUserInfo.student_all.joins(:t_duan_info).duan_orgnization.where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').where.not('t_user_info.F_id' => zs.pluck('t_user_info.F_id')).distinct.group('t_duan_info.F_name').count
        zs_wk1 = zs_wk.keys
        @duans_student_zs_wk = []
        nzs.each do |c|
            @duans_student_zs_wk << if zs_wk1.include?(c)
                                        zs_wk[c]
                                    else
                                        0
                                    end
        end

    else
        cw = TUserInfo.student_all.joins(:t_duan_info, :t_record_infoes).program_record(params[:name]).datetime.duan_orgnization.where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').distinct
        zs = TUserInfo.student_all.joins(:t_duan_info, :t_record_infoes).program_record(params[:name]).datetime.duan_orgnization.where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').distinct
        cw_ck = cw.group('t_duan_info.F_name').count
        cw_ck1 = cw_ck.keys
        @duans_student_cw_ck = []
        ncw.each do |c|
            @duans_student_cw_ck << if cw_ck1.include?(c)
                                        cw_ck[c]
                                    else
                                        0
                                    end
        end

        @duans_student_cw_ck_bl = []
        i = 0
        @duans_student_cw_ck.each do |v|
            @duans_student_cw_ck_bl << (BigDecimal(v) / BigDecimal(vcw[i])).round(3) * 100
            i += 1
        end

        cw_wk = TUserInfo.student_all.joins(:t_duan_info).duan_orgnization.where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').where.not('t_user_info.F_id' => cw.pluck('t_user_info.F_id')).distinct.group('t_duan_info.F_name').count
        cw_wk1 = cw_wk.keys
        @duans_student_cw_wk = []
        ncw.each do |c|
            @duans_student_cw_wk << if cw_wk1.include?(c)
                                        cw_wk[c]
                                    else
                                        0
                                    end
        end

        zs_ck = zs.group('t_duan_info.F_name').count
        zs_ck1 = zs_ck.keys
        @duans_student_zs_ck = []
        nzs.each do |c|
            @duans_student_zs_ck << if zs_ck1.include?(c)
                                        zs_ck[c]
                                    else
                                        0
                                    end
        end
        @duans_student_zs_ck_bl = []
        i = 0
        @duans_student_zs_ck.each do |v|
            @duans_student_zs_ck_bl << (BigDecimal(v) / BigDecimal(vzs[i])).round(3) * 100
            i += 1
        end

        zs_wk = TUserInfo.student_all.joins(:t_duan_info).duan_orgnization.where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').where.not('t_user_info.F_id' => zs.pluck('t_user_info.F_id')).distinct.group('t_duan_info.F_name').count
        zs_wk1 = zs_wk.keys
        @duans_student_zs_wk = []
        nzs.each do |c|
            @duans_student_zs_wk << if zs_wk1.include?(c)
                                        zs_wk[c]
                                    else
                                        0
                                    end
        end

    end
    gon.program_id = params[:id]
    gon.cwkey = ncw
    gon.cwwkvalue = @duans_student_cw_wk
    gon.cwckvalue = @duans_student_cw_ck
    gon.cwblvalue = @duans_student_cw_ck_bl
    gon.zsckblvalue = @duans_student_zs_ck_bl
    gon.zskey = nzs
    gon.zswkvalue = @duans_student_zs_wk
    gon.zsckvalue = @duans_student_zs_ck
    url = request.original_url
    arrurl = url.split('?')
    @para = arrurl[1]
  end

  def program_station_student_info
    @t_program_info = TProgramInfo.find(params[:id])
    @duan = TDuanInfo.find_by(F_name: params[:duan_name])
    @station_student = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.group('t_station_info.F_name').count
    n = @station_student.keys
    v = @station_student.values
    if params[:search].present?
        @search = TimeSearch.new(params[:search])
        m = @search.scope_program_student_info(params[:duan_name],params[:name]).select('t_user_info.F_id,t_station_info.F_name').distinct
        c = m.group('t_station_info.F_name').count
        c1 = c.keys
        @station_student_ck = []
        n.each do |n|
            @station_student_ck << if c1.include?(n)
                                       c[n]
                                   else
                                       0
                                   end
        end
        w = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.where.not('t_user_info.F_id' => m.pluck('t_user_info.F_id')).group('t_station_info.F_name').count
        w1 = w.keys
        @station_student_wk = []
        n.each do |n|
            @station_student_wk << if w1.include?(n)
                                       w[n]
                                   else
                                       0
                                   end
        end
    else
        m = TUserInfo.student_all.joins(:t_station_info, :t_record_infoes).datetime.program_record(params[:name]).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct
        c = m.group('t_station_info.F_name').count
        c1 = c.keys
        @station_student_ck = []
        n.each do |n|
            @station_student_ck << if c1.include?(n)
                                       c[n]
                                   else
                                       0
                                   end
        end
        w = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.where.not('t_user_info.F_id' => m.pluck('t_user_info.F_id')).group('t_station_info.F_name').count
        w1 = w.keys
        @station_student_wk = []
        n.each do |n|
            @station_student_wk << if w1.include?(n)
                                       w[n]
                                   else
                                       0
                                   end
        end

    end
        @station_student_ckbl = []
        i = 0
        @station_student_ck.each do |k|
          @station_student_ckbl << (BigDecimal(k) / BigDecimal(v[i])).round(3) * 100
          i += 1
        end
    gon.program_id = params[:id]
    gon.key = n
    gon.wkvalue = @station_student_wk
    gon.ckvalue = @station_student_ck
    gon.ckblvalue = @station_student_ckbl
  end

  def program_duan_score_info
    @t_program_info = TProgramInfo.find(params[:id])
    @duantype1 = TDuanInfo.where('t_duan_info.F_type= ?', 1).joins(t_user_infoes: :t_record_infoes).program_record(params[:name]).student_all
    @duantype2 = TDuanInfo.where('t_duan_info.F_type= ?', 2).joins(t_user_infoes: :t_record_infoes).program_record(params[:name]).student_all
    @duan = @duantype1.group('t_duan_info.F_name').distinct.count
    @duan_keys = @duan.keys
    @duan_keys2 = @duantype2.group('t_duan_info.F_name').distinct.count.keys

    if params[:search].present?
        @search = TimeSearch.new(params[:search])
        duan_90_cwscores = @search.scope_program_duan_score1(params[:name]).where('t_record_info.F_score > ?', 90).group('t_duan_info.F_name').size
        @duan_90_cwscores = []
        @duan_keys.each do |key|
          @duan_90_cwscores << if duan_90_cwscores.keys.include?(key)
                                duan_90_cwscores[key]
                              else
                                0
                              end
        end
        duan_80_cwscores = @search.scope_program_duan_score1(params[:name]).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_duan_info.F_name').size
        @duan_80_cwscores = []
        @duan_keys.each do |key|
          @duan_80_cwscores << if duan_80_cwscores.keys.include?(key)
                                duan_80_cwscores[key]
                              else
                                0
                              end
        end
        duan_60_cwscores = @search.scope_program_duan_score1(params[:name]).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_duan_info.F_name').size
        @duan_60_cwscores = []
        @duan_keys.each do |key|
          @duan_60_cwscores << if duan_60_cwscores.keys.include?(key)
                                duan_60_cwscores[key]
                              else
                                0
                              end
        end
        duan_60_cwbellow_scores = @search.scope_program_duan_score1(params[:name]).where('t_record_info.F_score < ?', 60).group('t_duan_info.F_name').size
        @duan_60_cwbellow_scores = []
        @duan_keys.each do |key|
          @duan_60_cwbellow_scores << if duan_60_cwbellow_scores.keys.include?(key)
                                      duan_60_cwbellow_scores
                                    else
                                      0
                                    end
        end
        #下面这段是直属站的柱状图信息
        duan_90_zsscores = @search.scope_program_duan_score2(params[:name]).where('t_record_info.F_score > ?', 90).group('t_duan_info.F_name').size
        @duan_90_zsscores = []
        @duan_keys2.each do |key|
          @duan_90_zsscores << if duan_90_zsscores.keys.include?(key)
                                duan_90_zsscores[key]
                              else
                                0
                              end
        end
        duan_80_zsscores = @search.scope_program_duan_score2(params[:name]).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_duan_info.F_name').size
        @duan_80_zsscores = []
        @duan_keys2.each do |key|
          @duan_80_zsscores << if duan_80_zsscores.keys.include?(key)
                                duan_80_zsscores[key]
                              else
                                0
                              end
        end
        duan_60_zsscores = @search.scope_program_duan_score2(params[:name]).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_duan_info.F_name').size
        @duan_60_zsscores = []
        @duan_keys2.each do |key|
          @duan_60_zsscores << if duan_60_zsscores.keys.include?(key)
                                duan_60_zsscores[key]
                              else
                                0
                              end
        end
        duan_60_zsbellow_scores = @search.scope_program_duan_score2(params[:name]).where('t_record_info.F_score < ?', 60).group('t_duan_info.F_name').size
        @duan_60_zsbellow_scores = []
        @duan_keys2.each do |key|
          @duan_60_zsbellow_scores << if duan_60_zsbellow_scores.keys.include?(key)
                                      duan_60_zsbellow_scores[key]
                                    else
                                      0
                                    end
        end
    else
        duan_90_cwscores = @duantype1.where('t_record_info.F_score > ?', 90).datetime.group('t_duan_info.F_name').size
        @duan_90_cwscores = []
        @duan_keys.each do |key|
          @duan_90_cwscores << if duan_90_cwscores.keys.include?(key)
                                duan_90_cwscores[key]
                              else
                                0
                              end
        end
        duan_80_cwscores = @duantype1.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).datetime.group('t_duan_info.F_name').size
        @duan_80_cwscores = []
        @duan_keys.each do |key|
          @duan_80_cwscores << if duan_80_cwscores.keys.include?(key)
                                duan_80_cwscores[key]
                              else
                                0
                              end
        end
        duan_60_cwscores = @duantype1.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).datetime.group('t_duan_info.F_name').size
        @duan_60_cwscores = []
        @duan_keys.each do |key|
          @duan_60_cwscores << if duan_60_cwscores.keys.include?(key)
                                duan_60_cwscores[key]
                              else
                                0
                              end
        end
        duan_60_cwbellow_scores = @duantype1.where('t_record_info.F_score < ?', 60).datetime.group('t_duan_info.F_name').size
        @duan_60_cwbellow_scores = []
        @duan_keys.each do |key|
          @duan_60_cwbellow_scores << if duan_60_cwbellow_scores.keys.include?(key)
                                      duan_60_cwbellow_scores[key]
                                    else
                                      0
                                    end
        end
        #下面这段是直属站的柱状图信息
        duan_90_zsscores = @duantype2.where('t_record_info.F_score > ?', 90).datetime.group('t_duan_info.F_name').size
        @duan_90_zsscores = []
        @duan_keys2.each do |key|
          @duan_90_zsscores << if duan_90_zsscores.keys.include?(key)
                                duan_90_zsscores[key]
                              else
                                0
                              end
        end
        duan_80_zsscores = @duantype2.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).datetime.group('t_duan_info.F_name').size
        @duan_80_zsscores = []
        @duan_keys2.each do |key|
          @duan_80_zsscores << if duan_80_zsscores.keys.include?(key)
                                duan_80_zsscores[key]
                              else
                                0
                              end
        end
        duan_60_zsscores = @duantype2.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).datetime.group('t_duan_info.F_name').size
        @duan_60_zsscores = []
        @duan_keys2.each do |key|
          @duan_60_zsscores << if duan_60_zsscores.keys.include?(key)
                                duan_60_zsscores[key]
                              else
                                0
                              end
        end
        duan_60_zsbellow_scores = @duantype2.where('t_record_info.F_score < ?', 60).datetime.group('t_duan_info.F_name').size
        @duan_60_zsbellow_scores = []
        @duan_keys2.each do |key|
          @duan_60_zsbellow_scores << if duan_60_zsbellow_scores.keys.include?(key)
                                      duan_60_zsbellow_scores[key]
                                    else
                                      0
                                    end
        end
  end
    gon.program_id = params[:id]
    gon.duan_key = @duan_keys
    gon.ninefen = @duan_90_cwscores
    gon.ef = @duan_80_cwscores
    gon.sf = @duan_60_cwscores
    gon.sb = @duan_60_cwbellow_scores
    #下列数据为直属站的柱状图
    gon.zsduan_key = @duan_keys2
    gon.zsnf = @duan_90_zsscores
    gon.zsef = @duan_80_zsscores
    gon.zssf = @duan_60_zsscores
    gon.zssb = @duan_60_zsbellow_scores
  end

  def program_reason_info
    @t_program_info = TProgramInfo.find(params[:id])
    if params[:search].present?
      @search = TimeSearch.new(params[:search])
      @duan_reasons = @search.scope_program_duan_reason(params[:name]).count.sort { |a, b| b[1] <=> a[1] }
    else
      @duan_reasons = TDetailReasonInfo.program_detail_reason(params[:name]).joins(:t_reason_info).datetime1.group('t_reason_info.F_name').size.sort { |a, b| b[1] <=> a[1] }
    end
  end

  def program_reason_student_info
    @t_program_info = TProgramInfo.find(params[:id])
    if params[:search].present?
      @search = TimeSearch.new(params[:search])
      records = @search.scope_program_duan_reason_student(params[:reason_name],params[:name])
      @records = case params[:order]
                  when "by_duan"
                    @records = records.order("F_duan_uuid DESC")
                  when "by_station"
                    @records = records.order("F_station_uuid DESC")
                  when "by_team"
                    @records = records.order("F_team_uuid DESC")
                  when "by_time"
                    @records = records.order("F_time DESC")
                  else
                    @records = records.order("F_score DESC")
                  end
    else
      records = TRecordInfo.datetime.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).joins(t_record_detail_infoes: { t_detail_reason_infoes: :t_reason_info }).program_detail_reason(params[:name]).where('t_reason_info.F_name = ?', params[:reason_name])
      @records = case params[:order]
                  when "by_duan"
                    @records = records.order("F_duan_uuid DESC")
                  when "by_station"
                    @records = records.order("F_station_uuid DESC")
                  when "by_team"
                    @records = records.order("F_team_uuid DESC")
                  when "by_time"
                    @records = records.order("F_time DESC")
                  else
                    @records = records.order("F_score DESC")
                  end

    end
  end

  def program_station_score_info
    @t_program_info = TProgramInfo.find(params[:id])
    @duan = TDuanInfo.find_by(F_name: params[:duan_name])
    @station = TStationInfo.where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).joins(t_user_infoes: :t_record_infoes).program_record(params[:name]).group('t_station_info.F_name').size
    @station_keys = @station.keys
    if params[:search].present?
        @search = TimeSearch.new(params[:search])
        station_90_scores = @search.scope_program_station_score(params[:duan_name],params[:name]).where('t_record_info.F_score >= ?', 90).group('t_station_info.F_name').size
        @station_90_scores = []
        @station_keys.each do |key|
          @station_90_scores << if station_90_scores.keys.include?(key)
                                    station_90_scores[key]
                                  else
                                    0
                                  end
        end
        station_80_scores = @search.scope_program_station_score(params[:duan_name],params[:name]).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_station_info.F_name').size
        @station_80_scores = []
        @station_keys.each do |key|
          @station_80_scores << if station_80_scores.keys.include?(key)
                                    station_80_scores[key]
                                  else
                                    0
                                  end
        end
        station_60_scores = @search.scope_program_station_score(params[:duan_name],params[:name]).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_station_info.F_name').size
        @station_60_scores = []
        @station_keys.each do |key|
          @station_80_scores << if station_60_scores.keys.include?(key)
                                    station_60_scores[key]
                                  else
                                    0
                                  end
        end
        station_60_bellow_scores = @search.scope_program_station_score(params[:duan_name],params[:name]).where('t_record_info.F_score < ?', 60).group('t_station_info.F_name').size
        @station_60_bellow_scores = []
        @station_keys.each do |key|
          @station_60_bellow_scores << if station_60_bellow_scores.keys.include?(key)
                                    station_60_bellow_scores[key]
                                  else
                                    0
                                  end
        end
    else
        station_90_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).joins(t_user_infoes: :t_record_infoes).program_record(params[:name]).datetime.where('t_record_info.F_score >= ?', 90).group('t_station_info.F_name').size
        @station_90_scores = []
        @station_keys.each do |key|
          @station_90_scores << if station_90_scores.keys.include?(key)
                                    station_90_scores[key]
                                  else
                                    0
                                  end
        end
        station_80_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?',  @duan.F_uuid).joins(t_user_infoes: :t_record_infoes).program_record(params[:name]).datetime.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_station_info.F_name').size
        @station_80_scores = []
        @station_keys.each do |key|
          @station_80_scores << if station_80_scores.keys.include?(key)
                                    station_80_scores[key]
                                  else
                                    0
                                  end
        end
        station_60_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?',  @duan.F_uuid).joins(t_user_infoes: :t_record_infoes).program_record(params[:name]).datetime.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_station_info.F_name').size
        @station_60_scores = []
        @station_keys.each do |key|
          @station_60_scores << if station_60_scores.keys.include?(key)
                                    station_60_scores[key]
                                  else
                                    0
                                  end
        end
        station_60_bellow_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).joins(t_user_infoes: :t_record_infoes).program_record(params[:name]).datetime.where('t_record_info.F_score < ?', 60).group('t_station_info.F_name').size
        @station_60_bellow_scores = []
        @station_keys.each do |key|
          @station_60_bellow_scores << if station_60_bellow_scores.keys.include?(key)
                                    station_60_bellow_scores[key]
                                  else
                                    0
                                  end
        end
  end
    gon.program_id = params[:id]
    gon.station_key = @station_keys
    gon.ninefen = @station_90_scores
    gon.ef = @station_80_scores
    gon.sf = @station_60_scores
    gon.sb = @station_60_bellow_scores
  end

  def program_team_student_info
    @t_program_info = TProgramInfo.find(params[:id])
    @duan = TDuanInfo.find_by(F_name: params[:duan_name])
    @station = TStationInfo.find_by(F_name: params[:station_name])
    @team_student = TUserInfo.student_all.joins(:t_team_info).where('t_team_info.F_station_uuid = ?', @station.F_uuid).select('t_user_info.F_name,t_user_info.F_id,t_team_info.F_name').distinct.group('t_team_info.F_name').count
    n= @team_student.keys
    @student_other = @station.t_user_infoes.where(:F_type => 0).where.not(:status => "在职").select(:F_id).distinct

    if params[:search].present?
      @search = TimeSearch.new(params[:search])
      if params[:team_name].present?
        @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
        student_id =@station.t_user_infoes.student_all.where(:F_team_uuid => @team.F_uuid).pluck(:F_id).uniq
        team_student = TUserInfo.all.where(:F_id => student_id)
        @student_ck = @search.scope_program_team_student2(team_student,params[:name]).select(:F_name, :F_id).distinct
        @student_wk = team_student.select(:F_name, :F_id).distinct.where.not(F_id: @student_ck.pluck(:F_id))
      else
        @student_ck = @search.scope_program_team_student3(@station,params[:name]).select(:F_name, :F_id).distinct
        @student_wk = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_uuid': @station.F_uuid).select(:F_name, :F_id).distinct.where.not(F_id: @student_ck.pluck(:F_id))
      end
      team = @station.t_team_infoes
      @key = []
      @value_ck = []
      @value_wk = []
      team.each do |t|
        student_id = @station.t_user_infoes.student_all.where(:F_team_uuid => t.F_uuid).pluck(:F_id).uniq
        student = TUserInfo.student_all.where(:F_id => student_id)
        if student.present?
          student_ck = @search.scope_program_team_student(student,params[:name]).pluck(:F_id).uniq
          student_wk = student.where.not(:F_id => student_ck).pluck(:F_id).uniq
          @key << t.F_name
          @value_ck << student_ck.size
          @value_wk << student_wk.size
        end
      end
    else
      if params[:team_name].present?
        @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
        student_id =@station.t_user_infoes.student_all.where(:F_team_uuid => @team.F_uuid).pluck(:F_id).uniq
        team_student = TUserInfo.all.where(:F_id => student_id)
        @student_ck = team_student.joins(:t_record_infoes).program_record(params[:name]).datetime.select(:F_name, :F_id).distinct
        @student_wk = team_student.select(:F_name, :F_id).distinct.where.not(F_id: @student_ck.pluck(:F_id))
      else
        @student_ck = TUserInfo.student_all.joins(:t_station_info, :t_record_infoes).where('t_station_info.F_uuid': @station.F_uuid).program_record(params[:name]).datetime.select(:F_name, :F_id).distinct
        @student_wk = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_uuid': @station.F_uuid).select(:F_name, :F_id).distinct.where.not(F_id: @student_ck.pluck(:F_id))
      end
      team = @station.t_team_infoes
      @key = []
      @value_ck = []
      @value_wk = []
      team.each do |t|
        student_id = @station.t_user_infoes.student_all.where(:F_team_uuid => t.F_uuid).pluck(:F_id).uniq
        student = TUserInfo.student_all.where(:F_id => student_id)
        if student.present?
          student_ck = student.joins(:t_record_infoes).program_record(params[:name]).datetime.pluck(:F_id).uniq
          student_wk = student.where.not(:F_id => student_ck).pluck(:F_id).uniq
          @key << t.F_name
          @value_ck << student_ck.size
          @value_wk << student_wk.size
        end
      end
    end
    gon.program_id = params[:id]
    gon.key = @key
    gon.wkvalue = @value_wk
    gon.ckvalue = @value_ck

    url = request.original_url
    arrurl = url.split('?')
    @para = arrurl[1]
  end

  def program_team_score_info

  end

  def program_student_records
    @duan = TDuanInfo.find_by(F_name: params[:duan_name])
    @station = TStationInfo.find_by(F_name: params[:station_name])
    if params[:team_name].present?
        @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
    end
    @students = TUserInfo.where(F_name: params[:user_name], F_id: params[:user_id])
    if params[:search].present?
        @search = TimeSearch.new(params[:search])
        @records = @search.scope_program_student_score(params[:user_id],params[:name])
    else
        @records = TRecordInfo.program_record(params[:name]).where(F_user_uuid: @students.ids).datetime
    end
  end

  def program_score_records

  end

  def program_record_details
    @duan = TDuanInfo.find_by(F_name: params[:duan_name])
    @station = TStationInfo.find_by(F_name: params[:station_name])
    if params[:team_name].present?
      @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
    end

    @students = TUserInfo.where(F_id: params[:user_id], F_name: params[:user_name])
    @record = TRecordInfo.find_by(F_uuid: params[:record_uuid])

    @t_record_detail_infoes = @record.t_record_detail_infoes
    @teacher = TUserInfo.find_by(F_uuid: @record.F_teacher_uuid)
  end

  def program_record_score_details

  end


end
