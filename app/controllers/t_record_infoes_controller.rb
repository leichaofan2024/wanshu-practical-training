class TRecordInfoesController < ApplicationController
  def index
    @duan = TDuanInfo.find_by(F_name: params[:duan])
    @station =TStationInfo.find_by(F_name: params[:station])
    @team = TTeamInfo.where(:F_station_uuid => @station.F_uuid).find_by(F_name: params[:team])
    @user = TUserInfo.find_by(F_id: params[:F_id])
    @records = TRecordInfo.joins(:t_user_info).where("t_user_info.F_id = ?",params[:F_id])
  end

  def student_records
    @duan = TDuanInfo.find_by(F_name: params[:duan_name])
    @station =TStationInfo.find_by(F_name: params[:name])
    @team = TTeamInfo.where(:F_station_uuid => @station.F_uuid).find_by(F_name: params[:team_name])
    students = TUserInfo.where(:F_name => params[:user_name],:F_id => params[:user_id])
    @records = TRecordInfo.where(:F_user_uuid => students.ids)

  end




end
