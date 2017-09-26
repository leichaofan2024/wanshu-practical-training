class TStationInfoesController < ApplicationController
    def index
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @stations = TStationInfo.all.where(F_duan_uuid: @duan.F_uuid)
    end

    def edit
        @station = TStationInfo.find(params[:id])
    end

    def update
        @station = TStationInfo.find(params[:id])
        @duan = @station.t_duan_info
        if @station.update(t_station_info_params)
            redirect_to team_student_info_t_team_infoes_path(duan_name: @duan.F_name, station_name: @station.F_name)
        else
            return :back
        end
    end

    def station_student_info
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station_student = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.group('t_station_info.F_name').count
        n = @station_student.keys
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = @search.scope_student_info(params[:duan_name]).select('t_user_info.F_id,t_station_info.F_name').distinct
          c = m.group('t_station_info.F_name').count
          c1=c.keys
          @station_student_ck = Array.new
          n.each do |n|
            if c1.include?(n)
              @station_student_ck << c[n]
            else
              @station_student_ck << 0
            end
          end
          w = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.where.not('t_user_info.F_id' => m.pluck('t_user_info.F_id')).group('t_station_info.F_name').count
          w1= w.keys
          @station_student_wk = Array.new
          n.each do |n|
            if w1.include?(n)
              @station_student_wk << w[n]
            else
              @station_student_wk << 0
            end
          end
        else
          m = TUserInfo.student_all.joins(:t_station_info, :t_record_infoes).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct
          c = m.group('t_station_info.F_name').count
          c1=c.keys
          @station_student_ck = Array.new
          n.each do |n|
            if c1.include?(n)
              @station_student_ck << c[n]
            else
              @station_student_ck << 0
            end
          end
          w = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.where.not('t_user_info.F_id' => m.pluck('t_user_info.F_id')).group('t_station_info.F_name').count
          w1= w.keys
          @station_student_wk = Array.new
          n.each do |n|
            if w1.include?(n)
              @station_student_wk << w[n]
            else
              @station_student_wk << 0
            end
          end

        end
        gon.key = n
        gon.wkvalue = @station_student_wk
        gon.ckvalue = @station_student_ck
    end

    def station_score_info
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            @station_90_scores = @search.scope_station_score(params[:duan_name]).where('t_record_info.F_score >= ?', 90).group('t_station_info.F_name').size
            @station_80_scores = @search.scope_station_score(params[:duan_name]).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_station_info.F_name').size
            @station_60_scores = @search.scope_station_score(params[:duan_name]).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_station_info.F_name').size
            @station_60_bellow_scores = @search.scope_station_score(params[:duan_name]).where('t_record_info.F_score < ?', 60).group('t_station_info.F_name').size
        else
            @station_90_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ?', 90).group('t_station_info.F_name').size
            @station_80_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?',  @duan.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_station_info.F_name').size
            @station_60_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?',  @duan.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_station_info.F_name').size
            @station_60_bellow_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score < ?', 60).group('t_station_info.F_name').size
      end
        gon.station_key = @station_90_scores.keys
        gon.ninefen = @station_90_scores.values
        gon.ef = @station_80_scores.values
        gon.sf = @station_60_scores.values
        gon.sb = @station_60_bellow_scores.values
    end

    private

    def t_station_info_params
        params.require(:t_station_info).permit(:F_name, :F_duan_uuid, :F_level, :Level, :image, :attachment, :attachment2)
    end
end
