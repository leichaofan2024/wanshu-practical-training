class TTeamInfoesController < ApplicationController
  def index
    @duan = TDuanInfo.find(params[:duan])
    @station = TStationInfo.find(params[:station])
    @teams = TTeamInfo.where(:F_station_uuid => params[:station])
  end
end
