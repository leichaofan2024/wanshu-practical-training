class TRecordInfoesController < ApplicationController
    def index
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.find_by(F_name: params[:station_name])
        @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
        @user = TUserInfo.find_by(F_id: params[:F_id])
        @records = TRecordInfo.joins(:t_user_info).where('t_user_info.F_id = ?', params[:F_id])
    end

    def show
      @t_record_info = TRecordInfo.find(params[:id]).F_record
    end
    def student_records
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.find_by(F_name: params[:station_name])
        if params[:team_name].present?
            @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
        end
        @students = TUserInfo.where(F_name: params[:user_name], F_id: params[:user_id])
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            @records = @search.scope_student_score(params[:user_id], params[:user_name])
        else
            @records = TRecordInfo.where(F_user_uuid: @students.ids).datetime
      end
    end

    def score_records
      @duan = TDuanInfo.find_by(F_name: params[:duan_name])
      @station = TStationInfo.find_by(F_name: params[:station_name])
      if params[:team_name].present?
        @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
      end
      @students = TUserInfo.where(F_name: params[:user_name], F_id: params[:user_id])

      if params[:search].present?
        @search = TimeSearch.new(params[:search])
        @records = @search.scope_student_score(params[:user_id], params[:user_name])
      else
        @records = TRecordInfo.where(F_user_uuid: @students.ids).datetime
      end
    end

    def destroy
      @record = TRecordInfo.find(params[:id])
      @record.destroy

      if params[:team_name].present?
        redirect_to student_records_t_record_infoes_path(:duan_name => params[:duan_name],:station_name => params[:station_name],:team_name=> params[:team_name],:user_name => params[:user_name],:user_id => params[:user_id])
      else
        redirect_to student_records_t_record_infoes_path(:duan_name => params[:duan_name],:station_name => params[:station_name],:user_name => params[:user_name],:user_id => params[:user_id])
      end

    end
end
