class TTeamInfoesController < ApplicationController
    def index
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.find_by(F_name: params[:station_name])
        @teams = TTeamInfo.where(F_station_uuid: @station.F_uuid)
    end

    def team_student_info
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.find_by(F_name: params[:station_name])
        @team_student = TUserInfo.student_all.joins(:t_team_info).where('t_team_info.F_station_uuid = ?', @station.F_uuid).select('t_user_info.F_name,t_user_info.F_id,t_team_info.F_name').distinct.group('t_team_info.F_name').count
        n= @team_student.keys


        if params[:search].present?
            @search = TimeSearch.new(params[:search])
          if params[:team_name].present?
            @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
            @student_ck = @search.scope_team_student2(@team).select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct
            @student_wk = TUserInfo.student_all.joins(:t_team_info).where('t_team_info.F_uuid=?', @team.F_uuid).select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct.where.not(F_id: @student_ck.pluck(:F_id))

          else
            @student_ck = @search.scope_team_student3(@station).select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct
            @student_wk = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_uuid': @station.F_uuid).select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct.where.not(F_id: @student_ck.pluck(:F_id))
          end
            m = @search.scope_team_student(params[:station_name]).select('t_user_info.F_name,t_user_info.F_id,t_team_info.F_name').distinct
            c = m.group('t_team_info.F_name').count
            c1 = c.keys
            @team_student_ck= Array.new
            n.each do |n|
              if c1.include?(n)
                @team_student_ck << c[n]
              else
                @team_student_ck << 0
              end
            end

            w = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(:t_user_infoes).where("t_user_info.F_type= ?", 0).select('t_user_info.F_name,t_user_info.F_id,t_team_info.F_name').where.not('t_user_info.F_name' => m.pluck('t_user_info.F_name')).distinct.group('t_team_info.F_name').count
            w1 = w.keys
            @team_student_wk = Array.new
            n.each do |n|
              if w1.include?(n)
                @team_student_wk << w[n]
              else
                @team_student_wk << 0
              end
            end
        else
          if params[:team_name].present?
            @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
            @student_ck = TUserInfo.student_all.joins(:t_team_info, :t_record_infoes).where('t_team_info.F_uuid =? ', @team.F_uuid).datetime.select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct
            @student_wk = TUserInfo.student_all.joins(:t_team_info).where('t_team_info.F_uuid=?', @team.F_uuid).select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct.where.not(F_id: @student_ck.pluck(:F_id))
          else
            @student_ck = TUserInfo.student_all.joins(:t_station_info, :t_record_infoes).where('t_station_info.F_uuid': @station.F_uuid).datetime.select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct
            @student_wk = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_uuid': @station.F_uuid).select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct.where.not(F_id: @student_ck.pluck(:F_id))
          end
            m = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(t_user_infoes: :t_record_infoes).datetime.where("t_user_info.F_type= ?", 0).select('t_user_info.F_name,t_user_info.F_id,t_team_info.F_name').distinct
            c = m.group('t_team_info.F_name').count
            c1 = c.keys
            @team_student_ck= Array.new
            n.each do |n|
              if c1.include?(n)
                @team_student_ck << c[n]
              else
                @team_student_ck << 0
              end
            end

            w = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(:t_user_infoes).where("t_user_info.F_type= ?", 0).select('t_user_info.F_name,t_user_info.F_id,t_team_info.F_name').where.not('t_user_info.F_name' => m.pluck('t_user_info.F_name')).distinct.group('t_team_info.F_name').count
            w1 = w.keys
            @team_student_wk = Array.new
            n.each do |n|
              if w1.include?(n)
                @team_student_wk << w[n]
              else
                @team_student_wk << 0
              end
            end

        end
        gon.key = n
        gon.wkvalue = @team_student_wk
        gon.ckvalue = @team_student_ck

        url = request.original_url
        arrurl = url.split('?')
        @para = arrurl[1]
    end

    def team_score_info
        @duan = TDuanInfo.find_by(F_name: params[:duan_name])
        @station = TStationInfo.find_by(F_name: params[:station_name])
        if params[:search].present?
              @search = TimeSearch.new(params[:search])
          if params[:team_name].present?
              @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
              @student_ck = @search.scope_student_ck(@team).select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct
              @student_wk = TUserInfo.student_all.joins(:t_team_info).where('t_team_info.F_uuid=?', @team.F_uuid).select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct.where.not(F_id: @student_ck.pluck(:F_id))
          else
            @student_ck = @search.scope_student_ck1(@station).select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct
            @student_wk = TUserInfo.student_all.joins(:t_team_info).where('t_team_info.F_uuid=?', @station.F_uuid).select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct.where.not(F_id: @student_ck.pluck(:F_id))
          end
            @search = TimeSearch.new(params[:search])
            @team_90_scores = @search.scope_team_score(params[:station_name]).where('t_record_info.F_score >= ?', 90).group('t_team_info.F_name').count
            @team_80_scores = @search.scope_team_score(params[:station_name]).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_team_info.F_name').count
            @team_60_scores = @search.scope_team_score(params[:station_name]).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_team_info.F_name').count
            @team_60_bellow_scores = @search.scope_team_score(params[:station_name]).where('t_record_info.F_score < ?', 60).group('t_team_info.F_name').count

        else
          if params[:team_name].present?
              @team = TTeamInfo.where(F_station_uuid: @station.F_uuid).find_by(F_name: params[:team_name])
              @student_ck = TUserInfo.student_all.joins(:t_team_info, :t_record_infoes).where('t_team_info.F_uuid =? ', @team.F_uuid).datetime.select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct
              @student_wk = TUserInfo.student_all.joins(:t_team_info).where('t_team_info.F_uuid=?', @team.F_uuid).select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct.where.not(F_id: @student_ck.pluck(:F_id))

          else
              @student_ck = TUserInfo.student_all.joins(:t_station_info, :t_record_infoes).where('t_station_info.F_uuid': @station.F_uuid).datetime.select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct
              @student_wk = TUserInfo.student_all.joins(:t_station_info).where('t_station_info.F_uuid': @station.F_uuid).select(:F_name, :F_id,:F_work_uuid,:F_team_uuid).distinct.where.not(F_id: @student_ck.pluck(:F_id))
              @team_score_90 = @student_ck.where('t_record_info.F_score >= ?', 90)
              @team_socre_80 = @student_ck.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90)
              @team_socre_60 = @student_ck.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80)
              @team_socre_60_bellow = @student_ck.where('t_record_info.F_score < ?', 60)
          end
            @team_90_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ?', 90).datetime.group('t_team_info.F_name').count
            @team_80_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).datetime.group('t_team_info.F_name').count
            @team_60_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).datetime.group('t_team_info.F_name').count
            @team_60_bellow_scores = TTeamInfo.where('t_team_info.F_station_uuid = ?', @station.F_uuid).joins(t_user_infoes: :t_record_infoes).where('t_record_info.F_score < ?', 60).datetime.group('t_team_info.F_name').count
        end
        gon.team_key = @team_90_scores.keys
        gon.ninefen = @team_90_scores.values
        gon.ef = @team_80_scores.values
        gon.sf = @team_60_scores.values
        gon.sb = @team_60_bellow_scores.values
    end
end
