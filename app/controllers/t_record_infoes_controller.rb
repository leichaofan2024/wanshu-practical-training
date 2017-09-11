class TRecordInfoesController < ApplicationController
  def index
    @duan = TDuanInfo.find_by(F_name: params[:duan])
    @station =TStationInfo.find_by(F_name: params[:station])
    @team = TTeamInfo.where(:F_station_uuid => @station.F_uuid).find_by(F_name: params[:team])
    @user = TUserInfo.find_by(F_id: params[:F_id])
    @records = TRecordInfo.joins(:t_user_info).where("t_user_info.F_id = ?",params[:F_id])
  end

end
