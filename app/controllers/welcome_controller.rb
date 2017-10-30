class WelcomeController < ApplicationController

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
    duan = TDuanInfo.where.not("t_duan_info.F_name = ? OR t_duan_info.F_name = ?", "运输处","局职教基地")
    cw = duan.where(:F_type => 1)
    zhi = duan.where(:F_type => 2)
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          @ck_cw = @search.scope_duan_cw_ck.where("t_user_info.F_type": 0).distinct.group('t_duan_info.F_name').count.keys
          @ck_zhi = @search.scope_duan_zhi_ck.where("t_user_info.F_type": 0).distinct.group("t_duan_info.F_name").count.keys
      else
        @ck_cw = cw.joins(t_user_infoes: :t_record_infoes).datetime.where("t_user_info.F_type": 0).distinct.group('t_duan_info.F_name').count.keys
        @ck_zhi = zhi.joins(t_user_infoes: :t_record_infoes).datetime.where("t_user_info.F_type": 0).distinct.group("t_duan_info.F_name").count.keys
      end
        @wk_cw = cw.pluck(:F_name) - @ck_cw
        @wk_zhi = zhi.pluck(:F_name) - @ck_zhi
  end

  def station_ck
    if params[:search].present?
        @search = TimeSearch.new(params[:search])
          if current_user.permission == 1
            station = TStationInfo.where.not("t_station_info.F_duan_uuid = ? OR t_station_info.F_duan_uuid=?",TDuanInfo.find_by(:F_name => "运输处").F_uuid, TDuanInfo.find_by(:F_name => "局职教基地").F_uuid)
            station_ck = @search.scope_station_ck.where("t_user_info.F_type": 0).distinct
            @wk_z = station.where.not(:F_uuid => station_ck.ids)
            @ck_z = station_ck
            @ck_stations = station_ck.group_by{|u| u.F_duan_uuid}
            @wk_stations = @wk_z.group_by{|u| u.F_duan_uuid}
          elsif current_user.permission ==2
            station = TStationInfo.where(:F_duan_uuid => TDuanInfo.find_by(:F_name => current_user.orgnize).F_uuid )
            station_ck = @search.scope_station2_ck.where("t_user_info.F_type": 0).distinct
            @wk_z = station.where.not(:F_uuid => station_ck.ids)
            @ck_z = station_ck
            @ck_stations = station_ck.group_by{|u| u.F_duan_uuid}
            @wk_stations = @wk_z.group_by{|u| u.F_duan_uuid}
          end
    else
          if current_user.permission == 1
            station = TStationInfo.where.not("t_station_info.F_duan_uuid = ? OR t_station_info.F_duan_uuid=?",TDuanInfo.find_by(:F_name => "运输处").F_uuid, TDuanInfo.find_by(:F_name => "局职教基地").F_uuid)
            station_ck = station.joins(t_user_infoes: :t_record_infoes).datetime.where("t_user_info.F_type": 0).distinct
            @wk_z = station.where.not(:F_uuid => station_ck.ids)
            @ck_z = station_ck
            @ck_stations = station_ck.group_by{|u| u.F_duan_uuid}
            @wk_stations = @wk_z.group_by{|u| u.F_duan_uuid}
          elsif current_user.permission ==2
            station = TStationInfo.where(:F_duan_uuid => TDuanInfo.find_by(:F_name => current_user.orgnize).F_uuid )
            station_ck = station.joins(t_user_infoes: :t_record_infoes).datetime.where("t_user_info.F_type": 0).distinct
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
            team = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name != '运输处' AND t_duan_info.F_name != '局职教基地'").where("t_user_info.F_type": 0).distinct
            teams_ck = @search.scope_team_ck.where("t_user_info.F_type" => 0).distinct
            teams_wk = team.where.not(:"t_team_info.F_uuid" => teams_ck.ids)
            @ck_z = TDuanInfo.duan_orgnization.joins(t_station_infoes: :t_team_infoes).where("t_team_info.F_uuid": teams_ck.ids)
            @wk_z = TDuanInfo.duan_orgnization.joins(t_station_infoes: :t_team_infoes).where("t_team_info.F_uuid": teams_wk.ids)
            @duans_ck = @ck_z.distinct
            @duans_wk = @wk_z .distinct


            if params[:duan_name].present?
              team_duan = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name=?",params[:duan_name]).where("t_user_info.F_type": 0).distinct
              team_ck = @search.scope_team_ck1(params[:duan_name]).where("t_user_info.F_type": 0).distinct
              @ck_teams = team_ck.group_by{|u| u.F_station_uuid}
              @wk_teams = team_duan.where.not(:F_uuid => team_ck.ids).group_by{|u| u.F_station_uuid}
            end
          elsif current_user.permission == 2
            @duans_ck = TDuanInfo.where("t_duan_info.F_name=?", current_user.orgnize)
            @duans_wk = TDuanInfo.where("t_duan_info.F_name=?", current_user.orgnize)

            if params[:duan_name].present?
              team_duan = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name=?",params[:duan_name]).where("t_user_info.F_type": 0).distinct
              team_ck = @search.scope_team_ck2(params[:duan_name]).where("t_user_info.F_type": 0).distinct
              @ck_teams = team_ck.group_by{|u| u.F_station_uuid}
              @wk_teams = team_duan.where.not(:F_uuid => team_ck.ids).group_by{|u| u.F_station_uuid}
            end
          elsif current_user.permission == 3
            team_station = TTeamInfo.joins(:t_station_info,:t_user_infoes).where("t_station_info.F_name": current_user.orgnize).where("t_user_info.F_type": 0).distinct
            @ck_teams = @search.scope_team_ck3(current_user.orgnize).where("t_user_info.F_type": 0).distinct
            @wk_teams = team_station.where.not(:F_uuid => @ck_teams.ids)
          end
    else
        if current_user.permission == 1
          team = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name != '运输处' AND t_duan_info.F_name != '局职教基地'").where("t_user_info.F_type": 0).distinct
          teams_ck = team.joins(t_user_infoes: :t_record_infoes).datetime.where("t_user_info.F_type" => 0).distinct
          teams_wk = team.where.not(:"t_team_info.F_uuid" => teams_ck.ids)
          @ck_z = TDuanInfo.duan_orgnization.joins(t_station_infoes: :t_team_infoes).where("t_team_info.F_uuid": teams_ck.ids)
          @wk_z = TDuanInfo.duan_orgnization.joins(t_station_infoes: :t_team_infoes).where("t_team_info.F_uuid": teams_wk.ids)
          @duans_ck = @ck_z.distinct
          @duans_wk = @wk_z .distinct


          if params[:duan_name].present?
            team_duan = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name=?",params[:duan_name]).where("t_user_info.F_type": 0).distinct
            team_ck = team_duan.joins(t_user_infoes: :t_record_infoes).datetime.where("t_user_info.F_type": 0).distinct
            @ck_teams = team_ck.group_by{|u| u.F_station_uuid}
            @wk_teams = team_duan.where.not(:F_uuid => team_ck.ids).group_by{|u| u.F_station_uuid}
          end
        elsif current_user.permission == 2
          @duans_ck = TDuanInfo.where("t_duan_info.F_name=?", current_user.orgnize)
          @duans_wk = TDuanInfo.where("t_duan_info.F_name=?", current_user.orgnize)

          if params[:duan_name].present?
            team_duan = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name=?",params[:duan_name]).where("t_user_info.F_type": 0).distinct
            team_ck = team_duan.joins(t_user_infoes: :t_record_infoes).datetime.where("t_user_info.F_type": 0).distinct
            @ck_teams = team_ck.group_by{|u| u.F_station_uuid}
            @wk_teams = team_duan.where.not(:F_uuid => team_ck.ids).group_by{|u| u.F_station_uuid}
          end
        elsif current_user.permission == 3
          team_station = TTeamInfo.joins(:t_station_info,:t_user_infoes).where("t_station_info.F_name": current_user.orgnize).where("t_user_info.F_type": 0).distinct
          @ck_teams = team_station.joins(t_user_infoes: :t_record_infoes).where("t_user_info.F_type": 0).distinct
          @wk_teams = team_station.where.not(:F_uuid => @ck_teams.ids)
        end
    end
  end

  def student_ck
    if params[:search].present?
          @search = TimeSearch.new(params[:search])
          if current_user.permission == 1
            student = TUserInfo.student_all
            students_duan_ck = @search.scope_student_duan_ck.distinct
            students_duan_wk = student.where.not("t_user_info.F_uuid": students_duan_ck.ids)
            @duans_ck = TDuanInfo.duan_orgnization.joins(:t_user_infoes).where("t_user_info.F_uuid": students_duan_ck.ids).distinct
            @duans_wk = TDuanInfo.duan_orgnization.joins(:t_user_infoes).where("t_user_info.F_uuid": students_duan_wk.ids).distinct

            if params[:duan_name].present?
              students_duan_ck = @search.scope_student_duan_ck1(params[:duan_name])
              students_duan_wk = student.where.not("t_user_info.F_uuid": students_duan_ck.ids)
              @ck_students = students_duan_ck.select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_duan_uuid,t_user_info.F_station_uuid,t_user_info.F_team_uuid").distinct.group_by{|u| u.F_station_uuid}
              @wk_students = students_duan_wk.joins(t_duan_info: :t_station_infoes).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_duan_uuid,t_user_info.F_station_uuid,t_user_info.F_team_uuid").distinct.group_by{|u| u.F_station_uuid}
            end
          elsif current_user.permission == 2
            student = TUserInfo.joins(:t_duan_info).where("t_duan_info.F_name": current_user.orgnize).student_all
            students_duan_ck = @search.scope_student_duan_ck2(current_user.orgnize)
            students_duan_wk = student.where.not("t_user_info.F_uuid": students_duan_ck.ids)
            @duans_ck = TDuanInfo.where("t_duan_info.F_name= ?",current_user.orgnize )
            @duans_wk = TDuanInfo.where("t_duan_info.F_name= ?",current_user.orgnize )

            if params[:duan_name].present?
              student = TUserInfo.joins(:t_duan_info).where("t_duan_info.F_name": current_user.orgnize).student_all
              students_duan_ck = @search.scope_student_duan_ck3(current_user.orgnize,params[:duan_name])
              students_duan_wk = student.where.not("t_user_info.F_uuid": students_duan_ck.ids)
              @ck_students = students_duan_ck.select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_duan_uuid,t_user_info.F_station_uuid,t_user_info.F_team_uuid").distinct.group_by{|u| u.F_station_uuid}
              @wk_students = students_duan_wk.joins(t_duan_info: :t_station_infoes).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_duan_uuid,t_user_info.F_station_uuid,t_user_info.F_team_uuid").distinct.group_by{|u| u.F_station_uuid}
            end
          elsif current_user.permission == 3
            team_station = TTeamInfo.joins(:t_station_info,:t_user_infoes).where("t_station_info.F_name": current_user.orgnize).where("t_user_info.F_type": 0).distinct
            @ck_teams = @search.scope_student_duan_ck4(current_user.orgnize).where("t_user_info.F_type": 0).distinct
            @wk_teams = team_station.where.not(:F_uuid => @ck_teams.ids)
          end
    else
        if current_user.permission == 1
          student = TUserInfo.student_all
          students_duan_ck = student.joins(:t_record_infoes).datetime.distinct
          students_duan_wk = student.where.not("t_user_info.F_uuid": students_duan_ck.ids)
          @duans_ck = TDuanInfo.duan_orgnization.joins(:t_user_infoes).where("t_user_info.F_uuid": students_duan_ck.ids).distinct
          @duans_wk = TDuanInfo.duan_orgnization.joins(:t_user_infoes).where("t_user_info.F_uuid": students_duan_wk.ids).distinct
          if params[:duan_name].present?
            @ck_students = students_duan_ck.joins(t_duan_info: :t_station_infoes).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_duan_uuid,t_user_info.F_station_uuid,t_user_info.F_team_uuid").distinct.group_by{|u| u.F_station_uuid}
            @wk_students = students_duan_wk.joins(t_duan_info: :t_station_infoes).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_duan_uuid,t_user_info.F_station_uuid,t_user_info.F_team_uuid").distinct.group_by{|u| u.F_station_uuid}
          end
        elsif current_user.permission == 2
          student = TUserInfo.joins(:t_duan_info).where("t_duan_info.F_name": current_user.orgnize).student_all
          students_duan_ck = student.joins(:t_record_infoes).datetime
          students_duan_wk = student.where.not("t_user_info.F_uuid": students_duan_ck.ids)
          @duans_ck = TDuanInfo.where("t_duan_info.F_name= ?",current_user.orgnize )
          @duans_wk = TDuanInfo.where("t_duan_info.F_name= ?",current_user.orgnize )

          if params[:duan_name].present?
            @ck_students = students_duan_ck.joins(t_duan_info: :t_station_infoes).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_duan_uuid,t_user_info.F_station_uuid,t_user_info.F_team_uuid").distinct.group_by{|u| u.F_station_uuid}
            @wk_students = students_duan_wk.joins(t_duan_info: :t_station_infoes).where("t_duan_info.F_name": params[:duan_name]).select("t_user_info.F_id,t_user_info.F_name,t_user_info.F_duan_uuid,t_user_info.F_station_uuid,t_user_info.F_team_uuid").distinct.group_by{|u| u.F_station_uuid}
          end
        elsif current_user.permission == 3
          team_station = TTeamInfo.joins(:t_station_info,:t_user_infoes).where("t_station_info.F_name": current_user.orgnize).where("t_user_info.F_type": 0).distinct
          @ck_teams = team_station.joins(t_user_infoes: :t_record_infoes).where("t_user_info.F_type": 0).distinct
          @wk_teams = team_station.where.not(:F_uuid => @ck_teams.ids)
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


end
