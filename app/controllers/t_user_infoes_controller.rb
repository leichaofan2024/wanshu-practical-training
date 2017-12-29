class TUserInfoesController < ApplicationController
  def index
    @duan = TDuanInfo.find_by(F_name: params[:duan_name])
    @station = TStationInfo.find_by(F_name: params[:station_name])
    @team = TTeamInfo.where(:F_station_uuid => @station.F_uuid).find_by(F_name: params[:team_name])
    @users = TUserInfo.where(:F_team_uuid => @team.F_uuid)
  end
  def set_student_status
    t_user_info = TUserInfo.find(params[:id])
    @t_user_infoes = TUserInfo.where(:F_id => t_user_info.F_id)
    @t_user_infoes.update_all(:status => params[:status])
    redirect_to :back
  end
end
