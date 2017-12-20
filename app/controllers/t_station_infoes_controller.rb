class TStationInfoesController < ApplicationController
  require 'bigdecimal'
  layout "notime_frame",only: [:status_edit]
    def index
        if current_user.permission == 1
          @duan = TDuanInfo.find_by(F_name: params[:duan_name])
          @stations = TStationInfo.all.where(F_duan_uuid: @duan.F_uuid)
        elsif current_user.permission == 2
          @stations = TDuanInfo.find_by(:F_name => current_user.orgnize).t_station_infoes
        end
    end

    def edit
        @station = TStationInfo.find(params[:id])
    end

    def status_edit
      @station = TStationInfo.find(params[:id])
    end

    def status_update
      @station = TStationInfo.find(params[:id])
      @duan = @station.t_duan_info
      if @station.update(t_station_info_params)
          redirect_to team_student_info_t_team_infoes_path(duan_name: @duan.F_name, station_name: @station.F_name)
      else
          return :back
      end
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
        v = @station_student.values
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_student_info(params[:duan_name]).select('t_user_info.F_id,t_station_info.F_name').distinct
            c = m.group('t_station_info.F_name').count
            c1 = c.keys
            @station_student_ck = []
            n.each do |n|
                @station_student_ck << if c1.include?(n)
                                           c[n]
                                       else
                                           0
                                       end
            end
            w = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.where.not('t_user_info.F_id' => m.pluck('t_user_info.F_id')).group('t_station_info.F_name').count
            w1 = w.keys
            @station_student_wk = []
            n.each do |n|
                @station_student_wk << if w1.include?(n)
                                           w[n]
                                       else
                                           0
                                       end
            end
        else
            m = TUserInfo.student_all.joins(:t_station_info, :t_record_infoes).datetime.where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct
            c = m.group('t_station_info.F_name').count
            c1 = c.keys
            @station_student_ck = []
            n.each do |n|
                @station_student_ck << if c1.include?(n)
                                           c[n]
                                       else
                                           0
                                       end
            end
            w = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.where.not('t_user_info.F_id' => m.pluck('t_user_info.F_id')).group('t_station_info.F_name').count
            w1 = w.keys
            @station_student_wk = []
            n.each do |n|
                @station_student_wk << if w1.include?(n)
                                           w[n]
                                       else
                                           0
                                       end
            end

        end
            @station_student_ckbl = []
            i = 0
            @station_student_ck.each do |k|
              @station_student_ckbl << (BigDecimal(k) / BigDecimal(v[i])).round(3) * 100
              i += 1
            end
        gon.key = n
        gon.wkvalue = @station_student_wk
        gon.ckvalue = @station_student_ck
        gon.ckblvalue = @station_student_ckbl
    end

    def station_score_info
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).joins(t_user_infoes: :t_record_infoes).group('t_station_info.F_name').size
        @station_keys = @station.keys
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            station_90_scores = @search.scope_station_score(params[:duan_name]).where('t_record_info.F_score >= ?', 90).group('t_station_info.F_name').size
            @station_90_scores = []
            @station_keys.each do |key|
              @station_90_scores << if station_90_scores.keys.include?(key)
                                        station_90_scores[key]
                                      else
                                        0
                                      end
            end
            station_80_scores = @search.scope_station_score(params[:duan_name]).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_station_info.F_name').size
            @station_80_scores = []
            @station_keys.each do |key|
              @station_80_scores << if station_80_scores.keys.include?(key)
                                        station_80_scores[key]
                                      else
                                        0
                                      end
            end
            station_60_scores = @search.scope_station_score(params[:duan_name]).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_station_info.F_name').size
            @station_60_scores = []
            @station_keys.each do |key|
              @station_80_scores << if station_60_scores.keys.include?(key)
                                        station_60_scores[key]
                                      else
                                        0
                                      end
            end
            station_60_bellow_scores = @search.scope_station_score(params[:duan_name]).where('t_record_info.F_score < ?', 60).group('t_station_info.F_name').size
            @station_60_bellow_scores = []
            @station_keys.each do |key|
              @station_60_bellow_scores << if station_60_bellow_scores.keys.include?(key)
                                        station_60_bellow_scores[key]
                                      else
                                        0
                                      end
            end
        else
            station_90_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).joins(t_user_infoes: :t_record_infoes).datetime.where('t_record_info.F_score >= ?', 90).group('t_station_info.F_name').size
            @station_90_scores = []
            @station_keys.each do |key|
              @station_90_scores << if station_90_scores.keys.include?(key)
                                        station_90_scores[key]
                                      else
                                        0
                                      end
            end
            station_80_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?',  @duan.F_uuid).joins(t_user_infoes: :t_record_infoes).datetime.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_station_info.F_name').size
            @station_80_scores = []
            @station_keys.each do |key|
              @station_80_scores << if station_80_scores.keys.include?(key)
                                        station_80_scores[key]
                                      else
                                        0
                                      end
            end
            station_60_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?',  @duan.F_uuid).joins(t_user_infoes: :t_record_infoes).datetime.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_station_info.F_name').size
            @station_60_scores = []
            @station_keys.each do |key|
              @station_80_scores << if station_60_scores.keys.include?(key)
                                        station_60_scores[key]
                                      else
                                        0
                                      end
            end
            station_60_bellow_scores = TStationInfo.where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).joins(t_user_infoes: :t_record_infoes).datetime.where('t_record_info.F_score < ?', 60).group('t_station_info.F_name').size
            @station_60_bellow_scores = []
            @station_keys.each do |key|
              @station_60_bellow_scores << if station_60_bellow_scores.keys.include?(key)
                                        station_60_bellow_scores[key]
                                      else
                                        0
                                      end
            end
      end
        gon.station_key = @station_keys
        gon.ninefen = @station_90_scores
        gon.ef = @station_80_scores
        gon.sf = @station_60_scores
        gon.sb = @station_60_bellow_scores
    end

    private

    def t_station_info_params
        params.require(:t_station_info).permit(:F_name, :F_duan_uuid, :F_level, :Level, :image,:status, :attachment, :attachment2)
    end
end
