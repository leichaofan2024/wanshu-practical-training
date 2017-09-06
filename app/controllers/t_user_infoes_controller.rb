class TUserInfoesController < ApplicationController
  def index
    @duan = TDuanInfo.find(params[:duan])
    @station = TStationInfo.find(params[:station])
    @team = TTeamInfo.find(params[:team])
    @users = TUserInfo.where(:F_team_uuid => params[:team])
  end
end
