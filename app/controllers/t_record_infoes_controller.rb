class TRecordInfoesController < ApplicationController
    def index
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.find_by(F_name: params[:station_name])
        @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
        @user = TUserInfo.find_by(F_id: params[:F_id])
        @records = TRecordInfo.joins(:t_user_info).where('t_user_info.F_id = ?', params[:F_id])
    end

    def student_records
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.find_by(F_name: params[:station_name])
        @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
        @students = TUserInfo.where(F_name: params[:user_name], F_id: params[:user_id])
        @records = TRecordInfo.where(F_user_uuid: @students.ids)
    end

    def destroy
        @record = TRecordInfo.find(params[:id])
        @record.destroy
        redirect_to team_student_info_t_team_infoes_path(duan_name: params[:duan_name], station_name: params[:station_name], team_name: params[:team_name])
    end
end
