class TRecordInfoesController < ApplicationController
  def index
    @duan = TDuanInfo.find(params[:duan])
    @station =TStationInfo.find(params[:station])
    @team = TTeamInfo.find(params[:team])
    @user = TUserInfo.find_by(:F_id => params[:F_id])
    @records = TRecordInfo.joins(:t_user_info).where("t_user_info.F_id = ?",params[:F_id])
  end

end
