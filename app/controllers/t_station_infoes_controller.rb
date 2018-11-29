class TStationInfoesController < ApplicationController
  require 'bigdecimal'
    def index
      if params[:search].present?
          @search = TimeSearch.new(params[:search])
        equipment_maintain = StationEquipmentMaintain.equipment_maintain(@search.date_from, @search.date_to)
        @station_name = TStationInfo.where(F_uuid: equipment_maintain).pluck("t_station_info.F_name").uniq
      else
        equipment_maintain = StationEquipmentMaintain.equipment_maintain(Time.now.beginning_of_month, Time.now.end_of_month)
        @station_name = TStationInfo.where(F_uuid: equipment_maintain).pluck("t_station_info.F_name").uniq
      end
      if current_user.permission == 1
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @stations = TStationInfo.all.where(F_duan_uuid: @duan.F_uuid)
      elsif current_user.permission == 2
        @stations = TDuanInfo.find_by(:F_name => current_user.orgnize).t_station_infoes
      end
    end

    def equipment_maintain_edit
      @duan = TDuanInfo.find_by(F_name: params[:duan_name])
      @station = TStationInfo.find_by(F_name: params[:station_name])
      equipment_maintain_edit = StationEquipmentMaintain.where(:station_name => @station.F_name)
      if equipment_maintain_edit.present? && (equipment_maintain_edit.last.end_time == "2030-01-01 00:00:00")
        @equipment_maintain_edit =  equipment_maintain_edit.last
      else
         @equipment_maintain_edit = StationEquipmentMaintain.new
      end

    end

    def equipment_maintain_create
      @station = TStationInfo.find_by(F_name: params[:station_name])

      @equipment_maintain_edit = StationEquipmentMaintain.new(:station_name => @station.F_name,:begin_time => Time.now,:equipment_come_from => params[:station_equipment_maintain]["equipment_come_from"],:equipment_used_time_lenth => params[:station_equipment_maintain]["equipment_used_time_lenth"],:maintain_reason => params[:station_equipment_maintain]["maintain_reason"],:t_type => params[:station_equipment_maintain]["t_type"])
      if @equipment_maintain_edit.save
        flash[:notice] = "设备状态成功设置为：'维修''!"
        redirect_to team_student_info_t_team_infoes_path(:duan_name => params[:duan_name],:station_name => params[:station_name])
      else
        flash[:alert] = "请把信息填写完整！"
        redirect_to equipment_maintain_edit_t_station_info_path(@station,:duan_name => params[:duan_name],:station_name => params[:station_name])
      end
    end

    def equipment_maintain_update
      @station = TStationInfo.find_by(F_name: params[:station_name])
      if params[:station_equipment_maintain][:equipment_come_from].present?
        StationEquipmentMaintain.find(params[:equipment_id]).update(:end_time => Time.now,:equipment_come_from => params[:station_equipment_maintain]["equipment_come_from"],:equipment_used_time_lenth => params[:station_equipment_maintain]["equipment_used_time_lenth"],:maintain_reason => params[:station_equipment_maintain]["maintain_reason"])
      else
        StationEquipmentMaintain.find(params[:equipment_id]).update(:end_time => Time.now)
      end
      flash[:notice] = "设备状态成功设置为：'在线'!"
      redirect_to team_student_info_t_team_infoes_path(:duan_name => params[:duan_name],:station_name => params[:station_name])
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

        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            @station_student = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.group('t_station_info.F_name').count
            n = @station_student.keys
            v = @station_student.values
            m_duan_student_ids = TUserInfo.student_all(@search.date_from, @search.date_to).where('t_user_info.F_duan_uuid = ?', @duan.F_uuid).pluck(:F_id).uniq
            m_student_ck_ids = @search.scope_student_info(m_duan_student_ids)
            m = TUserInfo.where(:F_id => m_student_ck_ids).joins(:t_station_info).where("t_station_info.F_duan_uuid = ?",@duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct
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
            w = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.where.not('t_user_info.F_id' => m.pluck('t_user_info.F_id')).group('t_station_info.F_name').count
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

          @station_student = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.group('t_station_info.F_name').count
          n = @station_student.keys
          v = @station_student.values
            m_duan_student_ids = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where('t_user_info.F_duan_uuid = ?', @duan.F_uuid).pluck(:F_id).uniq
            m_student_ck_ids = TUserInfo.where(:F_id => m_duan_student_ids).join(:t_record_infoes).datetime.pluck("t_user_info.F_id").uniq
            m = TUserInfo.where(:F_id => m_student_ck_ids).joins(:t_station_info).where("t_station_info.F_duan_uuid = ?",@duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct
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
            w = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.where.not('t_user_info.F_id' => m.pluck('t_user_info.F_id')).group('t_station_info.F_name').count
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

    def station_dabiao_info
      @duan = TDuanInfo.find_by(F_name: params[:duan_name])

      if params[:search].present?
          @search = TimeSearch.new(params[:search])
          @station_student = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.group('t_station_info.F_name').count
          n = @station_student.keys
          v = @station_student.values
          student_dabiao_ids =  TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params[:duan_name])).pluck(:F_id).uniq
          student_dabiao = @search.scope_dabiao_info(student_dabiao_ids)
          student_dabiao_f_id = Array.new
          student_dabiao.each do |key,value|
            if value >= 3600
              student_dabiao_f_id << key
            end
          end
          m = TUserInfo.student_all(@search.date_from, @search.date_to).where(F_id: student_dabiao_f_id).joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct
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
          w = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.where.not('t_user_info.F_id' => m.pluck('t_user_info.F_id')).group('t_station_info.F_name').count
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
        @station_student = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.group('t_station_info.F_name').count
        n = @station_student.keys
        v = @station_student.values
        student_dabiao_ids =  TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', TDuanInfo.find_by(F_name: params[:duan_name])).pluck(:F_id).uniq
        student_dabiao = TUserInfo.where(:F_id => student_dabiao_ids).joins( :t_record_infoes).datetime.group("t_user_info.F_id").sum("t_record_info.time_length")
        student_dabiao_f_id = []
        student_dabiao.each do |key,value|
          if value >= 3600
            student_dabiao_f_id << key
          end
        end
        m = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(F_id: student_dabiao_f_id).joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct
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
          w = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_station_info).where('t_station_info.F_duan_uuid = ?', @duan.F_uuid).select('t_user_info.F_id,t_station_info.F_name').distinct.where.not('t_user_info.F_id' => m.pluck('t_user_info.F_id')).group('t_station_info.F_name').count
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
              @station_60_scores << if station_60_scores.keys.include?(key)
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
        params.require(:t_station_info).permit(:status,:F_name, :F_duan_uuid, :F_level, :Level, {image: []}, {attachment: []}, {attachment2: []})
    end
end
