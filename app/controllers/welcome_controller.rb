class WelcomeController < ApplicationController
  before_action :all_browsed?
  layout "notime_frame",only: [:update_note]
  def ju_overview
    if current_user.permission == 2
      redirect_to duan_overview_path
    elsif current_user.permission == 3
      redirect_to station_overview_path
    end
  end

  def role
  end

  def duan_ck
    duan = TDuanInfo.duan_orgnization
    cw = duan.where(:F_type => 1)
    zhi = duan.where(:F_type => 2)
      if params[:search].present?
          @search = TimeSearch.new(params[:search])
          @ck_cw = @search.scope_duan_cw_ck.student_all(@search.date_from, @search.date_to).distinct.group('t_duan_info.F_name').count.keys
          @ck_zhi = @search.scope_duan_zhi_ck.student_all(@search.date_from, @search.date_to).distinct.group("t_duan_info.F_name").count.keys
      else
        @ck_cw = cw.joins(t_user_infoes: :t_record_infoes).datetime.student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct.group('t_duan_info.F_name').count.keys
        @ck_zhi = zhi.joins(t_user_infoes: :t_record_infoes).datetime.student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct.group("t_duan_info.F_name").count.keys
      end
        @wk_cw = cw.pluck(:F_name) - @ck_cw
        @wk_zhi = zhi.pluck(:F_name) - @ck_zhi
  end

  def station_ck
    if params[:search].present?
        @search = TimeSearch.new(params[:search])
          if current_user.permission == 1
            station = TStationInfo.station_orgnization.joins(:t_user_infoes).student_all(@search.date_from, @search.date_to).distinct
            station_ck = @search.scope_station_ck.student_all(@search.date_from, @search.date_to).distinct
            @wk_z = station.where.not(:F_uuid => station_ck.ids)
            @ck_z = station_ck
            @ck_stations = station_ck.group_by{|u| u.F_duan_uuid}
            @wk_stations = @wk_z.group_by{|u| u.F_duan_uuid}
          elsif current_user.permission ==2
            station = TStationInfo.where(:F_duan_uuid => TDuanInfo.find_by(:F_name => current_user.orgnize).F_uuid ).joins(:t_user_infoes).student_all(@search.date_from, @search.date_to).distinct
            station_ck = @search.scope_station_ck.student_all(@search.date_from, @search.date_to).distinct
            @wk_z = station.where.not(:F_uuid => station_ck.ids)
            @ck_z = station_ck
            @ck_stations = station_ck.group_by{|u| u.F_duan_uuid}
            @wk_stations = @wk_z.group_by{|u| u.F_duan_uuid}
          end
    else
          if current_user.permission == 1
            station = TStationInfo.station_orgnization.joins(:t_user_infoes).student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct
            station_ck = station.joins(t_user_infoes: :t_record_infoes).datetime.student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct
            @wk_z = station.where.not(:F_uuid => station_ck.ids)
            @ck_z = station_ck
            @ck_stations = station_ck.group_by{|u| u.F_duan_uuid}
            @wk_stations = @wk_z.group_by{|u| u.F_duan_uuid}
          elsif current_user.permission ==2
            station = TStationInfo.where(:F_duan_uuid => TDuanInfo.find_by(:F_name => current_user.orgnize).F_uuid ).joins(:t_user_infoes).student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct
            station_ck = station.joins(t_user_infoes: :t_record_infoes).datetime.student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct
            @wk_z = station.where.not(:F_uuid => station_ck.ids)
            @ck_z = station_ck
            @ck_stations = station_ck.group_by{|u| u.F_duan_uuid}
            @wk_stations = @wk_z.group_by{|u| u.F_duan_uuid}
          end
    end
  end

  def team_ck
    if params[:search].present?
          @search = TimeSearch.new(params[:search])
          if current_user.permission == 1
            team = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).duan_orgnization.student_all(@search.date_from, @search.date_to).distinct
            teams_ck = @search.scope_team_ck.student_all(@search.date_from, @search.date_to).distinct
            teams_wk = team.where.not(:"t_team_info.F_uuid" => teams_ck.ids)
            @ck_z = TDuanInfo.duan_orgnization.joins(t_station_infoes: :t_team_infoes).where("t_team_info.F_uuid": teams_ck.ids)
            @wk_z = TDuanInfo.duan_orgnization.joins(t_station_infoes: :t_team_infoes).where("t_team_info.F_uuid": teams_wk.ids)
            @duans_ck = @ck_z.distinct
            @duans_wk = @wk_z .distinct


            if params[:duan_name].present?
              team_duan = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name=?",params[:duan_name]).student_all(@search.date_from, @search.date_to).distinct
              team_ck = @search.scope_team_ck1(params[:duan_name]).student_all(@search.date_from, @search.date_to).distinct
              @ck_teams = team_ck.group_by{|u| u.F_station_uuid}
              @wk_teams = team_duan.where.not(:F_uuid => team_ck.ids).group_by{|u| u.F_station_uuid}
            end
          elsif current_user.permission == 2
            @duans_ck = TDuanInfo.where("t_duan_info.F_name=?", current_user.orgnize)
            @duans_wk = @duans_ck

            if params[:duan_name].present?
              team_duan = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name=?",params[:duan_name]).student_all(@search.date_from, @search.date_to).distinct
              team_ck = @search.scope_team_ck2(params[:duan_name]).student_all(@search.date_from, @search.date_to).distinct
              @ck_teams = team_ck.group_by{|u| u.F_station_uuid}
              @wk_teams = team_duan.where.not(:F_uuid => team_ck.ids).group_by{|u| u.F_station_uuid}
            end
          elsif current_user.permission == 3
            team_station = TTeamInfo.joins(:t_station_info,:t_user_infoes).where("t_station_info.F_name": current_user.orgnize).student_all(@search.date_from, @search.date_to).distinct
            @ck_teams = @search.scope_team_ck3(current_user.orgnize).student_all(@search.date_from, @search.date_to).distinct
            @wk_teams = team_station.where.not(:F_uuid => @ck_teams.ids)
          end
    else
        if current_user.permission == 1
          team = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).duan_orgnization.student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct
          teams_ck = team.joins(t_user_infoes: :t_record_infoes).datetime.student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct
          teams_wk = team.where.not(:"t_team_info.F_uuid" => teams_ck.ids)
          @ck_z = TDuanInfo.duan_orgnization.joins(t_station_infoes: :t_team_infoes).where("t_team_info.F_uuid": teams_ck.ids)
          @wk_z = TDuanInfo.duan_orgnization.joins(t_station_infoes: :t_team_infoes).where("t_team_info.F_uuid": teams_wk.ids)
          @duans_ck = @ck_z.distinct
          @duans_wk = @wk_z .distinct


          if params[:duan_name].present?
            team_duan = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name=?",params[:duan_name]).student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct
            team_ck = team_duan.joins(t_user_infoes: :t_record_infoes).datetime.student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct
            @ck_teams = team_ck.group_by{|u| u.F_station_uuid}
            @wk_teams = team_duan.where.not(:F_uuid => team_ck.ids).group_by{|u| u.F_station_uuid}
          end
        elsif current_user.permission == 2
          @duans_ck = TDuanInfo.where("t_duan_info.F_name=?", current_user.orgnize)
          @duans_wk = @duans_ck

          if params[:duan_name].present?
            team_duan = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name=?",params[:duan_name]).student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct
            team_ck = team_duan.joins(t_user_infoes: :t_record_infoes).datetime.student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct
            @ck_teams = team_ck.group_by{|u| u.F_station_uuid}
            @wk_teams = team_duan.where.not(:F_uuid => team_ck.ids).group_by{|u| u.F_station_uuid}
          end
        elsif current_user.permission == 3
          team_station = TTeamInfo.joins(:t_station_info,:t_user_infoes).where("t_station_info.F_name": current_user.orgnize).student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct
          @ck_teams = team_station.joins(t_user_infoes: :t_record_infoes).datetime.student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct
          @wk_teams = team_station.where.not(:F_uuid => @ck_teams.ids)
        end
    end
  end

  def student_ck
    if params[:search].present?
          @search = TimeSearch.new(params[:search])
          if current_user.permission == 1
            student = TUserInfo.student_all(@search.date_from, @search.date_to)
            student_ck_F_id = @search.scope_student_duan_ck.pluck("t_user_info.F_id").uniq
            students_duan_ck = student.where("t_user_info.F_id": student_ck_F_id)
            students_duan_wk = student.where.not("t_user_info.F_id": student_ck_F_id)
            @duans_ck = TDuanInfo.duan_orgnization.joins(:t_user_infoes).where("t_user_info.F_id": student_ck_F_id).distinct
            @duans_wk = TDuanInfo.duan_orgnization.joins(:t_user_infoes).where.not("t_user_info.F_id": student_ck_F_id).distinct

            if params[:duan_name].present?
              student_ck_F_id =@search.scope_student_duan_ck1(params[:duan_name]).select("t_user_info.F_id").uniq
              students_duan_ck = student.where("t_user_info.F_id": student_ck_F_id)
              students_duan_wk = student.where.not("t_user_info.F_uuid": student_ck_F_id)
              @ck_students = students_duan_ck.select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_station_uuid").distinct.group_by{|u| u.F_station_uuid}
              @wk_students = students_duan_wk.joins(:t_duan_info).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_station_uuid").distinct.group_by{|u| u.F_station_uuid}
            end
          elsif current_user.permission == 2
            student = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_duan_info).where("t_duan_info.F_name": current_user.orgnize)
            student_ck_F_id = @search.scope_student_duan_ck2(current_user.orgnize).pluck("t_user_info.F_id").uniq
            students_duan_ck = student.where("t_user_info.F_id": student_ck_F_id)
            students_duan_wk = student.where.not("t_user_info.F_id": student_ck_F_id)
            @duans_ck = TDuanInfo.where("t_duan_info.F_name= ?",current_user.orgnize ).joins(:t_user_infoes).where("t_user_info.F_id": student_ck_F_id).distinct
            @duans_wk = TDuanInfo.where("t_duan_info.F_name= ?",current_user.orgnize ).joins(:t_user_infoes).where.not("t_user_info.F_id": student_ck_F_id).distinct

            if params[:duan_name].present?
              student = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_duan_info).where("t_duan_info.F_name": current_user.orgnize)
              student_ck_F_id = @search.scope_student_duan_ck3(params[:duan_name]).pluck("t_user_info.F_id").uniq
              students_duan_ck = student.where("t_user_info.F_id": student_ck_F_id)
              students_duan_wk = student.where.not("t_user_info.F_uuid": student_ck_F_id)
              @ck_students = students_duan_ck.select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_station_uuid").distinct.group_by{|u| u.F_station_uuid}
              @wk_students = students_duan_wk.joins(:t_duan_info).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_station_uuid").distinct.group_by{|u| u.F_station_uuid}
            end
          elsif current_user.permission == 3

            station = TStationInfo.find_by(:F_name => current_user.orgnize)
            student_station = TUserInfo.student_all(@search.date_from, @search.date_to).where(F_station_uuid: station.F_uuid)
            student_team = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_team_info).where("t_team_info.F_station_uuid": station.F_uuid)
            student_team_id =  student_team.pluck(:F_id).uniq
            student_team_all = TUserInfo.student_all(@search.date_from, @search.date_to).where("t_user_info.F_id": student_team_id)

            student_ck_team_id = @search.scope_student_duan_ck4(student_team_all)
            student_wk_team_id = student_team.where.not(:F_id => student_ck_team_id).pluck(:F_id).uniq
            @ck_students = student_team.where(:F_id => student_ck_team_id).group_by{|u| u.F_team_uuid}
            @wk_students = student_team.where(:F_id => student_wk_team_id).group_by{|u| u.F_team_uuid}
          end
    else
        if current_user.permission == 1
          student = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month)
          student_ck_F_id = student.joins(:t_record_infoes).datetime.pluck("t_user_info.F_id").uniq
          students_duan_ck = student.where("t_user_info.F_id": student_ck_F_id)
          students_duan_wk = student.where.not("t_user_info.F_id": student_ck_F_id)
          @duans_ck = TDuanInfo.duan_orgnization.joins(:t_user_infoes).where("t_user_info.F_id": student_ck_F_id).distinct
          @duans_wk = TDuanInfo.duan_orgnization.joins(:t_user_infoes).where.not("t_user_info.F_id": student_ck_F_id).distinct
          if params[:duan_name].present?
            @ck_students = students_duan_ck.joins(:t_duan_info).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_station_uuid").distinct.group_by{|u| u.F_station_uuid}
            @wk_students = students_duan_wk.joins(:t_duan_info).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_station_uuid").distinct.group_by{|u| u.F_station_uuid}
          end
        elsif current_user.permission == 2
          student = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info).where("t_duan_info.F_name": current_user.orgnize)
          student_ck_F_id = student.joins(:t_record_infoes).datetime.pluck("t_user_info.F_id").uniq
          students_duan_ck = student.where("t_user_info.F_id": student_ck_F_id)
          students_duan_wk = student.where.not("t_user_info.F_id": student_ck_F_id)
          @duans_ck = TDuanInfo.where("t_duan_info.F_name= ?",current_user.orgnize ).joins(:t_user_infoes).where("t_user_info.F_id": student_ck_F_id).distinct
          @duans_wk = TDuanInfo.where("t_duan_info.F_name= ?",current_user.orgnize ).joins(:t_user_infoes).where.not("t_user_info.F_id": student_ck_F_id).distinct

          if params[:duan_name].present?
            @ck_students = students_duan_ck.joins(:t_duan_info).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_station_uuid").distinct.group_by{|u| u.F_station_uuid}
            @wk_students = students_duan_wk.joins(:t_duan_info).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_station_uuid").distinct.group_by{|u| u.F_station_uuid}
          end
        elsif current_user.permission == 3
          station = TStationInfo.find_by(:F_name => current_user.orgnize)
          student_station = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(F_station_uuid: station.F_uuid)
          student_team = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_team_info).where("t_team_info.F_station_uuid": station.F_uuid)
          student_team_id =  student_team.pluck(:F_id).uniq
          student_team_all = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(F_id: student_team_id)
          student_ck_team_id = student_team_all.joins(:t_record_infoes).datetime.distinct.pluck(:F_id).uniq
          student_wk_team_id = student_team.where.not(:F_id => student_ck_team_id).pluck(:F_id).uniq
          @ck_students = student_team.where(:F_id => student_ck_team_id).group_by{|u| u.F_team_uuid}
          @wk_students = student_team.where(:F_id => student_wk_team_id).group_by{|u| u.F_team_uuid}
        end
    end
  end

  def program_ck
    @program_types = TProgramTypeInfo.pluck(:F_name)
  if params[:search].present?
    @search = TimeSearch.new(params[:search])
    if current_user.permission == 1
      if params[:program_type].present?
        programs = TProgramInfo.where("t_program_info.F_type_id": TProgramTypeInfo.find_by(:F_name => params[:program_type]).F_id)
        ck_programs = @search.scope_program_ck(params[:program_type]).select("t_program_info.F_name,t_program_info.F_id").distinct
        @ck_programs = ck_programs.pluck("t_program_info.F_name")
        @wk_programs = programs.where.not(:F_id => ck_programs.ids).pluck("t_program_info.F_name")
      end
    elsif current_user.permission == 2
      if params[:program_type].present?
        programs = TProgramInfo.where("t_program_info.F_type_id": TProgramTypeInfo.find_by(:F_name => params[:program_type]).F_id)
        ck_programs = @search.scope_program_ck1(params[:program_type]).where("t_duan_info.F_name= ?", current_user.orgnize).select(:F_name,:F_type_id).distinct
        @ck_programs = ck_programs.pluck("t_program_info.F_name")
        @wk_programs = programs.where.not(:F_id => ck_programs.ids).pluck("t_program_info.F_name")
      end
    elsif current_user.permission == 3
      if params[:program_type].present?
        programs = TProgramInfo.where("t_program_info.F_type_id": TProgramTypeInfo.find_by(:F_name => params[:program_type]).F_id)
        ck_programs = @search.scope_program_ck2(params[:program_type]).where("t_station_info.F_name= ?", current_user.orgnize).select(:F_name,:F_type_id).distinct
        @ck_programs = ck_programs.pluck("t_program_info.F_name")
        @wk_programs = programs.where.not(:F_id => ck_programs.ids).pluck("t_program_info.F_name")
        end
      end
  else
    if current_user.permission == 1
      if params[:program_type].present?
        programs = TProgramInfo.where("t_program_info.F_type_id": TProgramTypeInfo.find_by(:F_name => params[:program_type]).F_id)
        ck_programs = programs.joins(:t_record_infoes).datetime.select("t_program_info.F_name,t_program_info.F_id").distinct
        @ck_programs = ck_programs.pluck("t_program_info.F_name")
        @wk_programs = programs.where.not(:F_id => ck_programs.ids).pluck("t_program_info.F_name")
      end
    elsif current_user.permission == 2
      if params[:program_type].present?
        programs = TProgramInfo.where("t_program_info.F_type_id": TProgramTypeInfo.find_by(:F_name => params[:program_type]).F_id)
        ck_programs = programs.joins(t_record_infoes: :t_duan_info).datetime.where("t_duan_info.F_name= ?", current_user.orgnize).select(:F_name,:F_type_id).distinct
        @ck_programs = ck_programs.pluck("t_program_info.F_name")
        @wk_programs = programs.where.not(:F_id => ck_programs.ids).pluck("t_program_info.F_name")
      end
    elsif current_user.permission == 3
      if params[:program_type].present?
        programs = TProgramInfo.where("t_program_info.F_type_id": TProgramTypeInfo.find_by(:F_name => params[:program_type]).F_id)
        ck_programs = programs.joins(t_record_infoes: :t_station_info).datetime.where("t_station_info.F_name= ?", current_user.orgnize).select(:F_name,:F_type_id).distinct
        @ck_programs = ck_programs.pluck("t_program_info.F_name")
        @wk_programs = programs.where.not(:F_id => ck_programs.ids).pluck("t_program_info.F_name")
        end
      end
    end
  end

  def baogao
    @kuaizhao = TBaogaoInfo.pluck(:created_at).uniq
    @baogao_program_select = TBaogaoProgram.pluck(:name)
    if params[:kuaizhao_duibi].present?
      @kuaizhao_duibi = TBaogaoInfo.where(:created_at => params[:kuaizhao_duibi].to_time)
    end

    if params[:kuaizhao_time].present?
      @kuaizhao_xiangqing = TBaogaoInfo.where(:created_at => params[:kuaizhao_time].to_time )
    end

    if params[:search].present?
      @search = TimeSearch.new(params[:search])
      @jibenqingkuang = TBaogaoInput.where(:title => "基本情况" ).where("t_baogao_inputs.baogao_time between ? and ?",@search.date_from,@search.date_to ).first
      @haodefangmian = TBaogaoInput.where(:title => "好的方面" ).where("t_baogao_inputs.baogao_time between ? and ?",@search.date_from,@search.date_to ).first
      @cunzaiwenti = TBaogaoInput.where(:title => "存在问题" ).where("t_baogao_inputs.baogao_time between ? and ?",@search.date_from,@search.date_to ).first
      @xiayuezhongdiangongzuo = TBaogaoInput.where(:title => "下月重点工作" ).where("t_baogao_inputs.baogao_time between ? and ?",@search.date_from,@search.date_to ).first
      @reason_hot_all = @search.scope_reason_hot.group(:F_name).count
      @programs_student = @search.scope_duan_program.group('t_program_info.F_name').count.sort { |a, b| b[1] <=> a[1] }
      @program_type = @search.scope_program_type
      @score_60_below = @search.scope_score.where('F_score< ? ', 60).count
      @score_60 = @search.scope_score.where('F_score >= ? AND F_score<? ', 60, 80).count
      @score_80 = @search.scope_score.where('F_score >= ? AND F_score<? ', 80, 90).count
      @score_90 = @search.scope_score.where('F_score >= ?', 90).count

      @team_online_all = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).duan_orgnization.student_all(@search.date_from, @search.date_to).distinct.count
      @team_cankao_all = @search.scope_team.distinct.count
      student_diaoli_uuid = TVacationInfo.student_transfer(@search.date_from,@search.date_to) + TUserInfo.where("t_user_info.status=? AND t_user_info.F_type = ?","调离",0).pluck(:F_uuid)
      @student_diaoli = TUserInfo.where(:F_uuid => student_diaoli_uuid).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name,t_user_info.F_id").distinct.group("t_duan_info.F_name").count

      @station_online = TStationInfo.joins(:t_duan_info,:t_user_infoes).duan_orgnization.student_all(@search.date_from, @search.date_to).select("t_duan_info.F_name,t_station_info.F_uuid").distinct.group("t_duan_info.F_name").count
      @student_yingkao = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name, t_user_info.F_id").distinct.group("t_duan_info.F_name").count

      @station_cankao = @search.scope_station_cankao
      @student_cankao = @search.scope_student_cankao
      student_dabiao = @search.scope_bg_student_dabiao
      dabiao_keys = []
      student_dabiao.each do |key,value|
        if value >= 3600
          dabiao_keys << key
        end
      end
      @student_dabiao = TUserInfo.where(:F_id => dabiao_keys).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name,t_user_info.F_id").distinct.group("t_duan_info.F_name").count


      if params[:name].present?
        @t_baogao_program = TBaogaoProgram.find_by(:name => params[:name])
        if @t_baogao_program.program_one.present?
          program_duan_student_hash = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values

          duan_ck = @search.scope_program_duan_student(@t_baogao_program.program_one).select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_one_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_one_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

        if @t_baogao_program.program_two.present?
          program_duan_student_hash = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values

          duan_ck = @search.scope_program_duan_student(@t_baogao_program.program_two).select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_two_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_two_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

        if @t_baogao_program.program_three.present?
          program_duan_student_hash = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values

          duan_ck = @search.scope_program_duan_student(@t_baogao_program.program_three).select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_three_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_three_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

        if @t_baogao_program.program_four.present?
          program_duan_student_hash = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values

          duan_ck = @search.scope_program_duan_student(@t_baogao_program.program_four).select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_four_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_four_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

        if @t_baogao_program.program_five.present?
          program_duan_student_hash = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values

          duan_ck = @search.scope_program_duan_student(@t_baogao_program.program_five).select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_five_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_five_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

        if @t_baogao_program.program_six.present?
          program_duan_student_hash = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values

          duan_ck = @search.scope_program_duan_student(@t_baogao_program.program_six).select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_six_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_six_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

        if @t_baogao_program.program_seven.present?
          program_duan_student_hash = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values

          duan_ck = @search.scope_program_duan_student(@t_baogao_program.program_seven).select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_seven_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_seven_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

        if @t_baogao_program.program_eight.present?
          program_duan_student_hash = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values

          duan_ck = @search.scope_program_duan_student(@t_baogao_program.program_eight).select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_eight_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_eight_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

      end

    else
      @jibenqingkuang = TBaogaoInput.where(:title => "基本情况" ).where("t_baogao_inputs.baogao_time between ? and ?",Time.now.beginning_of_month,Time.now.end_of_month ).first
      @haodefangmian = TBaogaoInput.where(:title => "好的方面" ).where("t_baogao_inputs.baogao_time between ? and ?",Time.now.beginning_of_month,Time.now.end_of_month ).first
      @cunzaiwenti = TBaogaoInput.where(:title => "存在问题" ).where("t_baogao_inputs.baogao_time between ? and ?",Time.now.beginning_of_month,Time.now.end_of_month).first
      @xiayuezhongdiangongzuo = TBaogaoInput.where(:title => "下月重点工作" ).where("t_baogao_inputs.baogao_time between ? and ?",Time.now.beginning_of_month,Time.now.end_of_month).first
      @reason_hot_all = TReasonInfo.joins(:t_detail_reason_infoes).datetime1.group(:F_name).count
      @score_60_below = TRecordInfo.where('F_score< ? ', 60).datetime.count
      @score_60 = TRecordInfo.where('F_score >= ? AND F_score<? ', 60, 80).datetime.count
      @score_80 = TRecordInfo.where('F_score >= ? AND F_score<? ', 80, 90).datetime.count
      @score_90 = TRecordInfo.where('F_score >= ?', 90).datetime.count
      @programs_student = TProgramInfo.joins(:t_record_infoes).datetime.group('t_program_info.F_name').count.sort { |a, b| b[1] <=> a[1] }
      @program_type = m = TProgramTypeInfo.joins(t_program_infoes: :t_record_infoes).datetime.group(:F_name).count
      @team_online_all = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).duan_orgnization.student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct.count
      @team_cankao_all = TTeamInfo.team_orgnization.joins(t_user_infoes: :t_record_infoes).student_all(Time.now.beginning_of_month, Time.now.end_of_month).datetime.distinct.count
      student_diaoli_uuid = TVacationInfo.student_transfer(Time.now.beginning_of_month,Time.now.end_of_month) + TUserInfo.where("t_user_info.status=? AND t_user_info.F_type = ?","调离",0).pluck(:F_uuid)
      @student_diaoli = TUserInfo.where(:F_uuid => student_diaoli_uuid).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name,t_user_info.F_id").distinct.group("t_duan_info.F_name").count

      @station_online = TStationInfo.joins(:t_duan_info,:t_user_infoes).duan_orgnization.student_all(Time.now.beginning_of_month, Time.now.end_of_month).select("t_duan_info.F_name,t_station_info.F_uuid").distinct.group("t_duan_info.F_name").count
      @student_yingkao = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name, t_user_info.F_id").distinct.group("t_duan_info.F_name").count

      @station_cankao = TStationInfo.joins(:t_duan_info,{t_user_infoes: :t_record_infoes}).duan_orgnization.student_all(Time.now.beginning_of_month, Time.now.end_of_month).datetime.select("t_duan_info.F_name,t_station_info.F_uuid").distinct.group("t_duan_info.F_name").count
      @student_cankao = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info,:t_record_infoes).duan_orgnization.datetime.select("t_duan_info.F_name, t_user_info.F_id").distinct.group("t_duan_info.F_name").count
      student_dabiao  = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info,:t_record_infoes).duan_orgnization.datetime.group("t_user_info.F_id").sum("t_record_info.time_length")
      dabiao_keys = []
      student_dabiao.each do |key,value|
        if value >= 3600
          dabiao_keys << key
        end
      end
      @student_dabiao = TUserInfo.where(:F_id => dabiao_keys).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name,t_user_info.F_id").distinct.group("t_duan_info.F_name").count


      if params[:name].present?
        @t_baogao_program = TBaogaoProgram.find_by(:name => params[:name])
        if @t_baogao_program.program_one.present?
          program_duan_student_hash = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values
          duan_ck = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info, :t_record_infoes).program_record(@t_baogao_program.program_one).datetime.duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_one_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_one_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

        if @t_baogao_program.program_two.present?
          program_duan_student_hash = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values

          duan_ck = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info, :t_record_infoes).program_record(@t_baogao_program.program_two).datetime.duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_two_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_two_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

        if @t_baogao_program.program_three.present?
          program_duan_student_hash = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values

          duan_ck = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info, :t_record_infoes).program_record(@t_baogao_program.program_three).datetime.duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_three_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_three_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

        if @t_baogao_program.program_four.present?
          program_duan_student_hash = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values

          duan_ck = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info, :t_record_infoes).program_record(@t_baogao_program.program_four).datetime.duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_four_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_four_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

        if @t_baogao_program.program_five.present?
          program_duan_student_hash = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values

          duan_ck = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info, :t_record_infoes).program_record(@t_baogao_program.program_five).datetime.duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_five_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_five_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

        if @t_baogao_program.program_six.present?
          program_duan_student_hash = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values

          duan_ck = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info, :t_record_infoes).program_record(@t_baogao_program.program_six).datetime.duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_six_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_six_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

        if @t_baogao_program.program_seven.present?
          program_duan_student_hash = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values

          duan_ck = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info, :t_record_infoes).program_record(@t_baogao_program.program_seven).datetime.duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_seven_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_seven_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

        if @t_baogao_program.program_eight.present?
          program_duan_student_hash = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info).duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
          key = program_duan_student_hash.keys
          value = program_duan_student_hash.values

          duan_ck = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info, :t_record_infoes).program_record(@t_baogao_program.program_eight).datetime.duan_orgnization.select('t_duan_info.F_name, t_user_info.F_id').distinct
          program_duan_ck_hash = duan_ck.group('t_duan_info.F_name').count
          ck_key = program_duan_ck_hash.keys
          @program_eight_ck_hash = program_duan_student_hash
          key.each do |k|
              @program_eight_ck_hash[k] = if ck_key.include?(k)
                                        program_duan_ck_hash[k]
                                      else
                                        0
                                      end
          end
        end

      end


    end
    @reason_hot_all8 = @reason_hot_all.sort_by { |a, b| b[1] <=> a[1] }.first(8)
    @reason_hot_all_sum = @reason_hot_all.values.sum
    @score_sum = @score_90 + @score_80 + @score_60 + @score_60_below
    @programs_student_all = @programs_student.first(5)
    @program_type_all = @program_type.values.sum
    @student_yingkao_all = @student_yingkao.values.sum
    @student_cankao_all = @student_cankao.values.sum
    @station_online_all = @station_online.values.sum
    @station_cankao_all = @station_cankao.values.sum
    @student_tuixiu = TUserInfo.where("t_user_info.status=? AND t_user_info.F_type = ?","退休",0).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name,t_user_info.F_id").distinct.group("t_duan_info.F_name").count

  end

  def update_note

  end

end
