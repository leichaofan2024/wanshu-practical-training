class TUserInfoesController < ApplicationController
  def index
    @duan = TDuanInfo.find_by(F_name: params[:duan_name])
    @station = TStationInfo.find_by(F_name: params[:station_name])
    @team = TTeamInfo.where(:F_station_uuid => @station.F_uuid).find_by(F_name: params[:team_name])
    @users = TUserInfo.where(:F_team_uuid => @team.F_uuid)
  end
  def set_student_status
    t_user_info = TUserInfo.find(params[:id])
    t_station_info = TStationInfo.find_by(:F_name => params[:station_name])
    @t_user_infoes = t_station_info.t_user_infoes.where(:F_id => t_user_info.F_id)
    @t_user_infoes.update_all(:status => params[:status])
    redirect_to :back
  end

  def set_vacation_status

    case params[:F_type]
    when "点击修复"
      @t_vacation_infoes = TVacationInfo.where(:F_id => params[:F_id],:F_type => "调离")
      if @t_vacation_infoes.blank? || @t_vacation_infoes.last.end_time.present?
        TVacationInfo.create(:F_id => params[:F_id],:begin_time => Time.now,:F_type => "调离")
      else
        @t_vacation_infoes.last.update(:end_time => Time.now)
      end
      TUserInfo.where(:F_id => params[:F_id],:F_station_uuid => TStationInfo.find_by(:F_name => params[:station_name]).F_uuid).update(:status => "在职")
    when "长假"
      @t_vacation_infoes = TVacationInfo.where(:F_id => params[:F_id],:F_type => params[:F_type])
      if @t_vacation_infoes.blank? || @t_vacation_infoes.last.end_time.present?
        TVacationInfo.create(:F_id => params[:F_id],:begin_time => Time.now,:F_type => params[:F_type])
      else
        @t_vacation_infoes.last.update(:end_time => Time.now)
      end
    when "短假"
      @t_vacation_infoes = TVacationInfo.where(:F_id => params[:F_id],:F_type => params[:F_type])
      if @t_vacation_infoes.blank? || @t_vacation_infoes.last.end_time.present?
        TVacationInfo.create(:F_id => params[:F_id],:begin_time => Time.now,:F_type => params[:F_type])
      else
        @t_vacation_infoes.last.update(:end_time => Time.now)
      end
    when "调离"
      @t_vacation_infoes = TVacationInfo.where(:F_id => params[:F_id],:F_type => params[:F_type],:station_name => params[:station_name])
      if @t_vacation_infoes.blank? || @t_vacation_infoes.last.end_time.present?
        TVacationInfo.create(:F_id => params[:F_id],:begin_time => Time.now,:F_type => params[:F_type],:station_name => params[:station_name])
      else
        @t_vacation_infoes.last.update(:end_time => Time.now)
      end
    end
    redirect_to :back
  end

  def destroy
    @station = TStationInfo.find_by(F_name: params[:station_name])
    @students = @station.t_user_infoes.where(:F_id => TUserInfo.find_by(:F_uuid => params[:id]).F_id)
    @students.destroy_all
    redirect_to :back
  end

end
