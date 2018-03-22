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

    if params[:search].present?
      @search = TimeSearch.new(params[:search])

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

    else
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
    end
    @student_tuixiu = TUserInfo.where("t_user_info.status=? AND t_user_info.F_type = ?","退休",0).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name,t_user_info.F_id").distinct.group("t_duan_info.F_name").count
    @student_diaoli = TUserInfo.where("t_user_info.status=? AND t_user_info.F_type = ?","调离",0).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name,t_user_info.F_id").distinct.group("t_duan_info.F_name").count
  end

  def update_note

  end

end
