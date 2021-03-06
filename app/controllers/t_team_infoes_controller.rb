class TTeamInfoesController < ApplicationController
    def index
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.find_by(F_name: params[:station_name])
        @teams = TTeamInfo.where(F_station_uuid: @station.F_uuid)
    end

    def team_student_info
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.where(F_duan_uuid: @duan.F_uuid).find_by(F_name: params[:station_name])
        @teams = @station.t_team_infoes
        @team_uuid_array = @teams.pluck(:F_uuid)
        @key = []
        @value_ck = []
        @value_wk = []

        if params[:search].present?
          @search = TimeSearch.new(params[:search])

          @team_student = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_team_info).where('t_team_info.F_station_uuid = ?', @station.F_uuid).select('t_user_info.F_name,t_user_info.F_id,t_team_info.F_name').distinct.group('t_team_info.F_name').count
          n= @team_student.keys
          @time_interval = {:date_from => @search.date_from ,:date_to => @search.date_to}
          @student_other = @station.t_user_infoes.where.not(F_id: @station.t_user_infoes.student_all(@search.date_from, @search.date_to).pluck("t_user_info.F_id")).where("t_user_info.F_type": 0).select("t_user_info.F_id").distinct

          if params[:team_name].present?
            @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
            student_id =@station.t_user_infoes.student_all(@search.date_from, @search.date_to).where(:F_team_uuid => @team.F_uuid).pluck(:F_id).uniq
            team_student = TUserInfo.where(:F_id => student_id)
            @student_ck = @search.scope_team_student2(team_student).select(:F_id).distinct
            # @student_ck= TUserInfo.where(:F_id => student_ck.pluck(:F_id))
            @student_wk = team_student.select(:F_id).distinct.where.not(F_id: @student_ck.pluck(:F_id))

            # @student_wk= TUserInfo.where(:F_id => student_wk.pluck(:F_id))
          else
            student_ids =  @search.scope_team_student_ids(@station)
            @student_ck = @search.scope_team_student3(student_ids).select(:F_id).distinct
            # @student_ck= TUserInfo.where(:F_id => student_ck.pluck(:F_id))
            @student_wk = TUserInfo.student_all(@search.date_from, @search.date_to).where(:F_station_uuid => @station.F_uuid).where.not(F_id: @student_ck.pluck(:F_id)).select(:F_id).distinct
            # @student_wk= TUserInfo.where(:F_id => student_wk.pluck(:F_id))
          end

          @teams.each do |t|
            student_id = @station.t_user_infoes.student_all(@search.date_from, @search.date_to).where(:F_team_uuid => t.F_uuid).pluck(:F_id).uniq
            student = TUserInfo.student_all(@search.date_from, @search.date_to).where(:F_id => student_id)
            if student.present?
              student_ck = @search.scope_team_student(student).pluck(:F_id).uniq
              student_wk = student.where.not(:F_id => student_ck).pluck(:F_id).uniq
              @key << t.F_name
              @value_ck << student_ck.size
              @value_wk << student_wk.size
            end
          end


        else
          @team_student = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_team_info).where('t_team_info.F_station_uuid = ?', @station.F_uuid).select('t_user_info.F_name,t_user_info.F_id,t_team_info.F_name').distinct.group('t_team_info.F_name').count
          n= @team_student.keys
          @time_interval = {:date_from => Time.now.beginning_of_month, :date_to => Time.now.end_of_month}
          @student_other = @station.t_user_infoes.where.not(F_id: @station.t_user_infoes.student_all(Time.now.beginning_of_month, Time.now.end_of_month).pluck("t_user_info.F_id")).where("t_user_info.F_type" => 0).select("t_user_info.F_id").distinct

          if params[:team_name].present?
            @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
            student_id =@station.t_user_infoes.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(:F_team_uuid => @team.F_uuid).pluck(:F_id).uniq
            team_student = TUserInfo.where(:F_id => student_id)
            @student_ck = team_student.joins(:t_record_infoes).datetime.select(:F_id).distinct
            # @student_ck= TUserInfo.where(:F_id => student_ck.pluck(:F_id))
            @student_wk = team_student.select(:F_id).distinct.where.not(F_id: @student_ck.pluck(:F_id))
            # @student_wk= TUserInfo.where(:F_id => student_wk.pluck(:F_id))
          else
            student_ids = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(:F_station_uuid => @station.F_uuid).pluck(:F_id).uniq
            @student_ck = TUserInfo.where(:F_id => student_ids).joins(:t_record_infoes).datetime.select(:F_id).distinct
            # @student_ck= TUserInfo.where(:F_id => student_ck.pluck(:F_id))
            @student_wk = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(:F_station_uuid => @station.F_uuid).where.not(F_id: @student_ck.pluck(:F_id)).select(:F_id).distinct
            # @student_wk= TUserInfo.where(:F_id => student_wk.pluck(:F_id))
          end

          @teams.each do |t|
            student_id = @station.t_user_infoes.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(:F_team_uuid => t.F_uuid).pluck(:F_id).uniq
            student = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(:F_id => student_id)
            if student.present?
              student_ck = student.joins(:t_record_infoes).datetime.pluck(:F_id).uniq
              student_wk = student.where.not(:F_id => student_ck).pluck(:F_id).uniq
              @key << t.F_name
              @value_ck << student_ck.size
              @value_wk << student_wk.size
            end
          end


        end
        gon.key = @key
        gon.wkvalue = @value_wk
        gon.ckvalue = @value_ck

        url = request.original_url
        arrurl = url.split('?')
        @para = arrurl[1]
    end

    def team_dabiao_info
      @duan = TDuanInfo.find_by(F_name: params[:duan_name])
      @station = TStationInfo.find_by(F_name: params[:station_name])
      @teams = @station.t_team_infoes
      @team_uuid_array = @teams.pluck(:F_uuid)
      if params[:search].present?
        @search = TimeSearch.new(params[:search])
        @team_student = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_team_info).where('t_team_info.F_station_uuid = ?', @station.F_uuid).select('t_user_info.F_name,t_user_info.F_id,t_team_info.F_name').distinct.group('t_team_info.F_name').count
        n= @team_student.keys
        @time_interval = {:date_from => @search.date_from  ,:date_to => @search.date_to }
        @student_other = @station.t_user_infoes.where.not(F_id: @station.t_user_infoes.student_all(@search.date_from, @search.date_to).pluck("t_user_info.F_id")).where("t_user_info.F_type": 0).select("t_user_info.F_id").distinct

        if params[:team_name].present?
          @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
          student_id =@station.t_user_infoes.student_all(@search.date_from, @search.date_to).where(:F_team_uuid => @team.F_uuid).pluck(:F_id).uniq
          team_student = TUserInfo.where(:F_id => student_id)
          student_dabiao = @search.scope_team_student2(team_student).group("t_user_info.F_id").sum("t_record_info.time_length")
          student_dabiao_f_id = []
          student_dabiao.each do |key,value|
            if value >= 3600
              student_dabiao_f_id << key
            end
          end

          @student_ck = TUserInfo.where(:F_id => student_dabiao_f_id).select(:F_id).distinct
          @student_wk = team_student.select(:F_id).distinct.where.not(F_id: @student_ck.pluck(:F_id))
        else
          student_ids = @search.scope_team_student_ids(@station)
          student_dabiao = @search.scope_team_student3(student_ids).group("t_user_info.F_id").sum("t_record_info.time_length")
          student_dabiao_f_id = []
          student_dabiao.each do |key,value|
            if value >= 3600
              student_dabiao_f_id << key
            end
          end
          @student_ck = TUserInfo.where(:F_id => student_dabiao_f_id).select(:F_id).distinct
          @student_wk = TUserInfo.student_all(@search.date_from, @search.date_to).where(:F_station_uuid =>  @station.F_uuid).where.not(F_id: @student_ck.pluck(:F_id)).select(:F_id).distinct
        end
        @key = []
        @value_ck = []
        @value_wk = []
        @teams.each do |t|
          student_id = @station.t_user_infoes.student_all(@search.date_from, @search.date_to).where(:F_team_uuid => t.F_uuid).pluck(:F_id).uniq
          student = TUserInfo.student_all(@search.date_from, @search.date_to).where(:F_id => student_id)
          if student.present?
            student_dabiao = @search.scope_team_student(student).group("t_user_info.F_id").sum("t_record_info.time_length")
            student_dabiao_f_id = []
            student_dabiao.each do |key, value|
              if value >= 3600
                student_dabiao_f_id << key
              end
            end

            student_ck = student_dabiao_f_id
            student_wk = student.where.not(:F_id => student_ck).pluck(:F_id).uniq
            @key << t.F_name
            @value_ck << student_ck.size
            @value_wk << student_wk.size
          end
        end
      else

        @team_student = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_team_info).where('t_team_info.F_station_uuid = ?', @station.F_uuid).select('t_user_info.F_name,t_user_info.F_id,t_team_info.F_name').distinct.group('t_team_info.F_name').count
        n= @team_student.keys
        @time_interval = {:date_from => Time.now.beginning_of_month, :date_to => Time.now.end_of_month}
        @student_other = @station.t_user_infoes.where.not(F_id: @station.t_user_infoes.student_all(Time.now.beginning_of_month, Time.now.end_of_month).pluck("t_user_info.F_id")).where("t_user_info.F_type": 0).select("t_user_info.F_id").distinct


        if params[:team_name].present?

          @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
          student_id =@station.t_user_infoes.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(:F_team_uuid => @team.F_uuid).pluck(:F_id).uniq
          team_student = TUserInfo.all.where(:F_id => student_id)
          student_dabiao = team_student.joins(:t_record_infoes).datetime.group("t_user_info.F_id").sum("t_record_info.time_length")
          student_dabiao_f_id = []
          student_dabiao.each do |key, value|
            if value >= 3600
              student_dabiao_f_id << key
            end
          end
          @student_ck = TUserInfo.where(:F_id => student_dabiao_f_id).select(:F_id).distinct
          @student_wk = team_student.select(:F_id).distinct.where.not(F_id: @student_ck.pluck(:F_id))
        else
          student_ids = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(:F_station_uuid => @station.F_uuid).pluck(:F_id).uniq
          student_dabiao = TUserInfo.where(:F_id => student_ids).joins(:t_record_infoes).datetime.group("t_user_info.F_id").sum("t_record_info.time_length")
          student_dabiao_f_id = []
          student_dabiao.each do |key, value|
            if value >= 3600
              student_dabiao_f_id << key
            end
          end
          @student_ck = TUserInfo.where(:F_id => student_dabiao_f_id).select(:F_id).distinct
          @student_wk = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(:F_station_uuid => @station.F_uuid).where.not(F_id: @student_ck.pluck(:F_id)).select(:F_id).distinct
        end
        @key = []
        @value_ck = []
        @value_wk = []
        @teams.each do |t|
          student_id = @station.t_user_infoes.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(:F_team_uuid => t.F_uuid).pluck(:F_id).uniq
          student = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(:F_id => student_id)
          if student.present?
            student_dabiao = student.joins(:t_record_infoes).datetime.group("t_user_info.F_id").sum("t_record_info.time_length")
            student_dabiao_f_id = []
            student_dabiao.each do |key, value|
              if value >= 3600
                student_dabiao_f_id << key
              end
            end
            student_ck = student_dabiao_f_id
            student_wk = student.where.not(:F_id => student_ck).pluck(:F_id).uniq
            @key << t.F_name
            @value_ck << student_ck.size
            @value_wk << student_wk.size
          end
        end
      end
      gon.key = @key
      gon.wkvalue = @value_wk
      gon.ckvalue = @value_ck

      url = request.original_url
      arrurl = url.split('?')
      @para = arrurl[1]
    end

    def team_score_info
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.find_by(F_name: params[:station_name])
        @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
        @team_keys = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(t_user_infoes: :t_record_infoes).group('t_team_info.F_name').size.keys
        if params[:search].present?
              @search = TimeSearch.new(params[:search])
          if params[:team_name].present?
              @student_ck = @search.scope_student_ck(@team).select(:F_name, :F_id,:F_work_uuid,:F_team_uuid,:F_score)
          else
              @student_ck = @search.scope_student_ck1(@station).select(:F_name, :F_id,:F_work_uuid,:F_team_uuid,:F_score)
          end
            team_90_scores = @search.scope_team_score(@station).where('t_record_info.F_score >= ?', 90).group('t_team_info.F_name').size
            @team_90_scores = []
              @team_keys.each do |key|
                @team_90_scores << if team_90_scores.keys.include?(key)
                                      team_90_scores[key]
                                    else
                                      0
                                    end
            end
            team_80_scores = @search.scope_team_score(@station).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_team_info.F_name').size
            @team_80_scores = []
              @team_keys.each do |key|
                @team_80_scores << if team_80_scores.keys.include?(key)
                                      team_80_scores[key]
                                    else
                                      0
                                    end
            end
            team_60_scores = @search.scope_team_score(@station).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_team_info.F_name').size
            @team_60_scores = []
              @team_keys.each do |key|
                @team_60_scores << if team_60_scores.keys.include?(key)
                                      team_60_scores[key]
                                    else
                                      0
                                    end
            end
            team_60_bellow_scores = @search.scope_team_score(@station).where('t_record_info.F_score < ?', 60).group('t_team_info.F_name').size
            @team_60_bellow_scores = []
              @team_keys.each do |key|
                @team_60_bellow_scores << if team_60_bellow_scores.keys.include?(key)
                                      team_60_bellow_scores[key]
                                    else
                                      0
                                    end
            end
            #下面信息为成绩页面中，按照成绩进行筛选所用信息。
            @team_score_90 = @student_ck.where('t_record_info.F_score >= ?', 90).sort_by{|s| s.F_score}.reverse
            @team_score_80 = @student_ck.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).sort_by{|s| s.F_score}.reverse
            @team_score_60 = @student_ck.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).sort_by{|s| s.F_score}.reverse
            @team_score_60_bellow = @student_ck.where('t_record_info.F_score < ?', 60).sort_by{|s| s.F_score}.reverse
        else
          if params[:team_name].present?
              @student_ck = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_team_info, :t_record_infoes).where('t_team_info.F_uuid =? ', @team.F_uuid).datetime.select(:F_name, :F_id,:F_work_uuid,:F_team_uuid,:F_score)
          else
              @student_ck = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_station_info, :t_record_infoes).where('t_station_info.F_uuid': @station.F_uuid).datetime.select(:F_name, :F_id,:F_work_uuid,:F_team_uuid,:F_score)
          end
              @team_score_90 = @student_ck.where('t_record_info.F_score >= ?', 90).sort_by{|s| s.F_score}.reverse
              @team_score_80 = @student_ck.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).sort_by{|s| s.F_score}.reverse
              @team_score_60 = @student_ck.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).sort_by{|s| s.F_score}.reverse
              @team_score_60_bellow = @student_ck.where('t_record_info.F_score < ?', 60).sort_by{|s| s.F_score}.reverse
          #下面这一层，为柱状图中所用信息。
            team_90_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ?', 90).datetime.group('t_team_info.F_name').size
            @team_90_scores = []
              @team_keys.each do |key|
                @team_90_scores << if team_90_scores.keys.include?(key)
                                      team_90_scores[key]
                                    else
                                      0
                                    end
            end
            team_80_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? AND t_record_info.F_score < ?', 80, 90).datetime.group('t_team_info.F_name').size
            @team_80_scores = []
              @team_keys.each do |key|
                @team_80_scores << if team_80_scores.keys.include?(key)
                                      team_80_scores[key]
                                    else
                                      0
                                    end
            end
            team_60_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? AND t_record_info.F_score < ?', 60, 80).datetime.group('t_team_info.F_name').size
            @team_60_scores = []
              @team_keys.each do |key|
                @team_60_scores << if team_60_scores.keys.include?(key)
                                      team_60_scores[key]
                                    else
                                      0
                                    end
            end
            team_60_bellow_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score < ?', 60).datetime.group('t_team_info.F_name').size
            @team_60_bellow_scores = []
              @team_keys.each do |key|
                @team_60_bellow_scores << if team_60_bellow_scores.keys.include?(key)
                                      team_60_bellow_scores[key]
                                    else
                                      0
                                    end
            end
        end
        gon.team_key = @team_keys
        gon.ninefen = @team_90_scores
        gon.ef = @team_80_scores
        gon.sf = @team_60_scores
        gon.sb = @team_60_bellow_scores
    end
end
