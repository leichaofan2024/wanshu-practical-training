class TRecordDetailInfoesController < ApplicationController
  def record_details
      @duan = TDuanInfo.find_by(F_name: params[:duan_name])
      @station = TStationInfo.find_by(F_name: params[:station_name])
      if params[:team_name].present?
        @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
      end

      @students = TUserInfo.where(F_id: params[:user_id], F_name: params[:user_name])
      @record = TRecordInfo.find_by(F_uuid: params[:record_uuid])

      @t_record_detail_infoes = @record.t_record_detail_infoes
      @teacher = TUserInfo.find_by(F_uuid: @record.F_teacher_uuid)
  end

  def record_score_details
    @duan = TDuanInfo.find_by(F_name: params[:duan_name])
    @station = TStationInfo.find_by(F_name: params[:station_name])
    if params[:team_name].present?
      @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
    end

    @students = TUserInfo.where(F_id: params[:user_id], F_name: params[:user_name])
    @record = TRecordInfo.find_by(F_uuid: params[:record_uuid])

    @t_record_detail_infoes = @record.t_record_detail_infoes
    @teacher = TUserInfo.find_by(F_uuid: @record.F_teacher_uuid)
  end
end
