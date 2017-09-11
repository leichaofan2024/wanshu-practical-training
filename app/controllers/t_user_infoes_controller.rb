class TUserInfoesController < ApplicationController
  def index
    @duan = TDuanInfo.find_by(F_name: params[:duan])
    @station = TStationInfo.find_by(F_name: params[:station])
    @team = TTeamInfo.where(:F_station_uuid => @station.F_uuid).find_by(F_name: params[:team])
    @users = TUserInfo.where(:F_team_uuid => @team.F_uuid)
  end
end
