class TDuanInfoesController < ApplicationController
  require 'bigdecimal'
    def index
        @duans_cw = TDuanInfo.duan_orgnization.where(F_type: 1)
        @duans_zs = TDuanInfo.duan_orgnization.where(F_type: 2)
        @duans_zj = TDuanInfo.duan_zhijiao
    end

    def duan_student_info
        @duans = TDuanInfo.where.not(F_name: %w(运输处 局职教基地))
        @duans_student_cw = TUserInfo.where(F_type: 0).joins(:t_duan_info).where.not('t_duan_info.F_name' => %w(局职教基地 运输处)).where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
        ncw = @duans_student_cw.keys
        vcw = @duans_student_cw.values
        @duans_student_zs = TUserInfo.where(F_type: 0).joins(:t_duan_info).where.not('t_duan_info.F_name =? or t_duan_info.F_name =? ', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').distinct.group('t_duan_info.F_name').count
        nzs = @duans_student_zs.keys
        vzs = @duans_student_zs.values
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            cw = @search.scope_duan_student.where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').distinct
            zs = @search.scope_duan_student.where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').distinct
            cw_ck = cw.group('t_duan_info.F_name').count
            cw_ck1 = cw_ck.keys
            @duans_student_cw_ck = []
            ncw.each do |c|
                @duans_student_cw_ck << if cw_ck1.include?(c)
                                            cw_ck[c]
                                        else
                                            0
                                        end
            end
            @duans_student_cw_ck_bl = []
            i = 0
            @duans_student_cw_ck.each do |v|
                @duans_student_cw_ck_bl << (BigDecimal(v) / BigDecimal(vcw[i])).round(3) * 100
                i += 1
            end
            cw_wk = TUserInfo.where(F_type: 0).joins(:t_duan_info).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').where.not('t_user_info.F_id' => cw.pluck('t_user_info.F_id')).distinct.group('t_duan_info.F_name').count
            cw_wk1 = cw_ck.keys
            @duans_student_cw_wk = []
            ncw.each do |c|
                @duans_student_cw_wk << if cw_wk1.include?(c)
                                            cw_wk[c]
                                        else
                                            0
                                        end
            end

            zs_ck = zs.group('t_duan_info.F_name').count
            zs_ck1 = zs_ck.keys
            @duans_student_zs_ck = []
            nzs.each do |c|
                @duans_student_zs_ck << if zs_ck1.include?(c)
                                            zs_ck[c]
                                        else
                                            0
                                        end
            end
            @duans_student_zs_ck_bl = []
            i = 0
            @duans_student_zs_ck.each do |v|
                @duans_student_zs_ck_bl << (BigDecimal(v) / BigDecimal(vzs[i])).round(3) * 100
                i += 1
            end
            zs_wk = TUserInfo.where(F_type: 0).joins(:t_duan_info).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').where.not('t_user_info.F_id' => zs.pluck('t_user_info.F_id')).distinct.group('t_duan_info.F_name').count
            zs_wk1 = zs_wk.keys
            @duans_student_zs_wk = []
            nzs.each do |c|
                @duans_student_zs_wk << if zs_wk1.include?(c)
                                            zs_wk[c]
                                        else
                                            0
                                        end
            end

        else
            cw = TUserInfo.where(F_type: 0).joins(:t_duan_info, :t_record_infoes).datetime.where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').distinct
            zs = TUserInfo.where(F_type: 0).joins(:t_duan_info, :t_record_infoes).datetime.where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').distinct
            cw_ck = cw.group('t_duan_info.F_name').count
            cw_ck1 = cw_ck.keys
            @duans_student_cw_ck = []
            ncw.each do |c|
                @duans_student_cw_ck << if cw_ck1.include?(c)
                                            cw_ck[c]
                                        else
                                            0
                                        end
            end

            @duans_student_cw_ck_bl = []
            i = 0
            @duans_student_cw_ck.each do |v|
                @duans_student_cw_ck_bl << (BigDecimal(v) / BigDecimal(vcw[i])).round(3) * 100
                i += 1
            end

            cw_wk = TUserInfo.where(F_type: 0).joins(:t_duan_info).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 1).select('t_duan_info.F_name, t_user_info.F_id').where.not('t_user_info.F_id' => cw.pluck('t_user_info.F_id')).distinct.group('t_duan_info.F_name').count
            cw_wk1 = cw_ck.keys
            @duans_student_cw_wk = []
            ncw.each do |c|
                @duans_student_cw_wk << if cw_wk1.include?(c)
                                            cw_wk[c]
                                        else
                                            0
                                        end
            end

            zs_ck = zs.group('t_duan_info.F_name').count
            zs_ck1 = zs_ck.keys
            @duans_student_zs_ck = []
            nzs.each do |c|
                @duans_student_zs_ck << if zs_ck1.include?(c)
                                            zs_ck[c]
                                        else
                                            0
                                        end
            end
            @duans_student_zs_ck_bl = []
            i = 0
            @duans_student_zs_ck.each do |v|
                @duans_student_zs_ck_bl << (BigDecimal(v) / BigDecimal(vzs[i])).round(3) * 100
                i += 1
            end

            zs_wk = TUserInfo.where(F_type: 0).joins(:t_duan_info).where.not('t_duan_info.F_name =? or t_duan_info.F_name =?', '局职教基地', '运输处').where('t_duan_info.F_type= ?', 2).select('t_duan_info.F_name, t_user_info.F_id').where.not('t_user_info.F_id' => zs.pluck('t_user_info.F_id')).distinct.group('t_duan_info.F_name').count
            zs_wk1 = zs_wk.keys
            @duans_student_zs_wk = []
            nzs.each do |c|
                @duans_student_zs_wk << if zs_wk1.include?(c)
                                            zs_wk[c]
                                        else
                                            0
                                        end
            end

        end
        gon.cwkey = ncw
        gon.cwwkvalue = @duans_student_cw_wk
        gon.cwckvalue = @duans_student_cw_ck
        gon.cwblvalue = @duans_student_cw_ck_bl
        gon.zsckblvalue = @duans_student_zs_ck_bl
        gon.zskey = nzs
        gon.zswkvalue = @duans_student_zs_wk
        gon.zsckvalue = @duans_student_zs_ck
    end

    def duan_score_info
        @duantype1 = TDuanInfo.where('t_duan_info.F_type= ?', 1).joins(t_user_infoes: :t_record_infoes)
        @duantype2 = TDuanInfo.where('t_duan_info.F_type= ?', 2).joins(t_user_infoes: :t_record_infoes)
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            @duan_90_cwscores = @search.scope_duan_score1.where('t_record_info.F_score > ?', 90).group('t_duan_info.F_name').size
            @duan_80_cwscores = @search.scope_duan_score1.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_duan_info.F_name').size
            @duan_60_cwscores = @search.scope_duan_score1.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_duan_info.F_name').size
            @duan_60_cwbellow_scores = @search.scope_duan_score1.where('t_record_info.F_score < ?', 60).group('t_duan_info.F_name').size
            @duan_90_zsscores = @search.scope_duan_score2.where('t_record_info.F_score > ?', 90).group('t_duan_info.F_name').size
            @duan_80_zsscores = @search.scope_duan_score2.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).group('t_duan_info.F_name').size
            @duan_60_zsscores = @search.scope_duan_score2.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).group('t_duan_info.F_name').size
            @duan_60_zsbellow_scores = @search.scope_duan_score2.where('t_record_info.F_score < ?', 60).group('t_duan_info.F_name').size
        else
            @duan_90_cwscores = @duantype1.where('t_record_info.F_score > ?', 90).datetime.group('t_duan_info.F_name').size
            @duan_80_cwscores = @duantype1.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).datetime.group('t_duan_info.F_name').size
            @duan_60_cwscores = @duantype1.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).datetime.group('t_duan_info.F_name').size
            @duan_60_cwbellow_scores = @duantype1.where('t_record_info.F_score < ?', 60).datetime.group('t_duan_info.F_name').size
            @duan_90_zsscores = @duantype2.where('t_record_info.F_score > ?', 90).datetime.group('t_duan_info.F_name').size
            @duan_80_zsscores = @duantype2.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 80, 90).datetime.group('t_duan_info.F_name').size
            @duan_60_zsscores = @duantype2.where('t_record_info.F_score >= ? and t_record_info.F_score < ?', 60, 80).datetime.group('t_duan_info.F_name').size
            @duan_60_zsbellow_scores = @duantype2.where('t_record_info.F_score < ?', 60).datetime.group('t_duan_info.F_name').size
      end
        gon.duan_key = @duan_90_cwscores.keys
        gon.ninefen = @duan_90_cwscores.values
        gon.ef = @duan_80_cwscores.values
        gon.sf = @duan_60_cwscores.values
        gon.sb = @duan_60_cwbellow_scores.values
        gon.zsduan_key = @duan_90_zsscores.keys
        gon.zsnf = @duan_90_zsscores.values
        gon.zsef = @duan_80_zsscores.values
        gon.zssf = @duan_60_zsscores.values
        gon.zssb = @duan_60_zsbellow_scores.values
    end

    def duan_program_info
      if  params[:search].present?
        @search = TimeSearch.new(params[:search])
        if current_user.permission == 1
            @duan_programs = @search.scope_duan_program.group('t_program_info.F_name').size.sort { |a, b| b[1] <=> a[1] }
        elsif current_user.permission == 2
            @duan_programs = @search.scope_duan_program1(current_user.orgnize).group('t_program_info.F_name').size.sort { |a, b| b[1] <=> a[1] }
        elsif current_user.permission == 3
            @duan_programs = @search.scope_duan_program2.where('t_station_info.F_name = ?', current_user.orgnize).group('t_program_info.F_name').size.sort { |a, b| b[1] <=> a[1] }
        end
      else
        if current_user.permission == 1
            @duan_programs = TProgramInfo.joins(:t_record_infoes).datetime.group('t_program_info.F_name').size.sort { |a, b| b[1] <=> a[1] }
        elsif current_user.permission == 2
            @duan_programs = TProgramInfo.joins(t_record_infoes: :t_duan_info ).datetime.where('t_duan_info.F_name = ?', current_user.orgnize).group('t_program_info.F_name').size.sort { |a, b| b[1] <=> a[1] }
        elsif current_user.permission == 3
            @duan_programs = TProgramInfo.joins(t_record_infoes: :t_station_info ).datetime.where('t_station_info.F_name = ?', current_user.orgnize).group('t_program_info.F_name').size.sort { |a, b| b[1] <=> a[1] }
        end
      end
    end

    def duan_program_student_info
      if params[:search].present?
        @search = TimeSearch.new(params[:search])
        if current_user.permission == 1
          records = @search.scope_duan_program_student.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).joins(:t_program_infoes).where('t_program_info.F_name = ?', params[:name])
          @records =  case params[:order]
                      when "by_duan"
                        @records = records.order("F_duan_uuid DESC")
                      when "by_station"
                        @records = records.order("F_station_uuid DESC")
                      when "by_team"
                        @records = records.order("F_team_uuid DESC")
                      when "by_time"
                        @records = records.order("F_time DESC")
                      else
                        @records = records.order("F_score DESC")
                      end

        elsif current_user.permission == 2
          records = @search.scope_duan_program_student.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).joins(:t_program_infoes).where('t_program_info.F_name = ?', params[:name]).where('t_record_info.F_duan_uuid=?', TDuanInfo.find_by(F_name: current_user.orgnize).F_uuid)
          @records = case params[:order]
                      when "by_duan"
                        @records = records.order("F_duan_uuid DESC")
                      when "by_station"
                        @records = records.order("F_station_uuid DESC")
                      when "by_team"
                        @records = records.order("F_team_uuid DESC")
                      when "by_time"
                        @records = records.order("F_time DESC")
                      else
                        @records = records.order("F_score DESC")
                      end


        elsif current_user.permission == 3
          records = @search.scope_duan_program_student.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).joins(:t_program_infoes).where('t_program_info.F_name = ?', params[:name]).where('t_record_info.F_station_uuid=?', TStationInfo.find_by(F_name: current_user.orgnize).F_uuid)
            @records = case params[:order]
                        when "by_duan"
                          @records = records.order("F_duan_uuid DESC")
                        when "by_station"
                          @records = records.order("F_station_uuid DESC")
                        when "by_team"
                          @records = records.order("F_team_uuid DESC")
                        when "by_time"
                          @records = records.order("F_time DESC")
                        else
                          @records = records.order("F_score DESC")
                        end

        end

      else

        if current_user.permission == 1
          records = TRecordInfo.datetime.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).joins(:t_program_infoes).where('t_program_info.F_name = ?', params[:name])
          @records =  case params[:order]
                      when "by_duan"
                        @records = records.order("F_duan_uuid DESC")
                      when "by_station"
                        @records = records.order("F_station_uuid DESC")
                      when "by_team"
                        @records = records.order("F_team_uuid DESC")
                      when "by_time"
                        @records = records.order("F_time DESC")
                      else
                        @records = records.order("F_score DESC")
                      end

        elsif current_user.permission == 2
          records = TRecordInfo.datetime.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).joins(:t_program_infoes).where('t_program_info.F_name = ?', params[:name]).where('t_record_info.F_duan_uuid=?', TDuanInfo.find_by(F_name: current_user.orgnize).F_uuid)
          @records = case params[:order]
                      when "by_duan"
                        @records = records.order("F_duan_uuid DESC")
                      when "by_station"
                        @records = records.order("F_station_uuid DESC")
                      when "by_team"
                        @records = records.order("F_team_uuid DESC")
                      when "by_time"
                        @records = records.order("F_time DESC")
                      else
                        @records = records.order("F_score DESC")
                      end


        elsif current_user.permission == 3
          records = TRecordInfo.datetime.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).joins(:t_program_infoes).where('t_program_info.F_name = ?', params[:name]).where('t_record_info.F_station_uuid=?', TStationInfo.find_by(F_name: current_user.orgnize).F_uuid)
            @records = case params[:order]
                        when "by_duan"
                          @records = records.order("F_duan_uuid DESC")
                        when "by_station"
                          @records = records.order("F_station_uuid DESC")
                        when "by_team"
                          @records = records.order("F_team_uuid DESC")
                        when "by_time"
                          @records = records.order("F_time DESC")
                        else
                          @records = records.order("F_score DESC")
                        end
        end
      end

    end

    def duan_reason_info
        if params[:search].present?
            if current_user.permission == 1
                @search = TimeSearch.new(params[:search])
                @duan_reasons = @search.scope_duan_reason.count.sort { |a, b| b[1] <=> a[1] }
            elsif current_user.permission == 2
                 @search = TimeSearch.new(params[:search])
                 @duan_reasons = @search.scope_duan_reason1(current_user.orgnize).count.sort { |a, b| b[1] <=> a[1] }
            elsif current_user.permission == 3
                 @search = TimeSearch.new(params[:search])
                 @duan_reasons = @search.scope_duan_reason2(current_user.orgnize).count.sort { |a, b| b[1] <=> a[1] }
            end
        else
            if current_user.permission == 1
                @duan_reasons = TDetailReasonInfo.joins(:t_reason_info).datetime1.group('t_reason_info.F_name').size.sort { |a, b| b[1] <=> a[1] }
            elsif current_user.permission == 2
                @duan_reasons = TDetailReasonInfo.joins(:t_reason_info, t_record_detail_info: { t_record_info: :t_duan_info }).datetime1.where('t_duan_info.F_name = ?', current_user.orgnize).group('t_reason_info.F_name').size.sort { |a, b| b[1] <=> a[1] }
            elsif current_user.permission == 3
                @duan_reasons = TDetailReasonInfo.joins(:t_reason_info, t_record_detail_info: { t_record_info: :t_station_info }).datetime1.where('t_station_info.F_name = ?', current_user.orgnize).group('t_reason_info.F_name').size.sort { |a, b| b[1] <=> a[1] }
            end
        end

        url = request.original_url
        arr = url.split('?')
        @para = arr[1]
    end

    def duan_reason_student_info
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
          if current_user.permission == 1
            records = @search.scope_duan_reason_student(params[:name])
            @records = case params[:order]
                        when "by_duan"
                          @records = records.order("F_duan_uuid DESC")
                        when "by_station"
                          @records = records.order("F_station_uuid DESC")
                        when "by_team"
                          @records = records.order("F_team_uuid DESC")
                        when "by_time"
                          @records = records.order("F_time DESC")
                        else
                          @records = records.order("F_score DESC")
                        end
          elsif current_user.permission == 2
            records = @search.scope_duan_reason_student(params[:name])
            @records = case params[:order]
                        when "by_duan"
                          @records = records.order("F_duan_uuid DESC")
                        when "by_station"
                          @records = records.order("F_station_uuid DESC")
                        when "by_team"
                          @records = records.order("F_team_uuid DESC")
                        when "by_time"
                          @records = records.order("F_time DESC")
                        else
                          @records = records.order("F_score DESC")
                        end
          elsif current_user.permission == 3
            records = @search.scope_duan_reason_student(params[:name])
            @records = case params[:order]
                        when "by_duan"
                          @records = records.order("F_duan_uuid DESC")
                        when "by_station"
                          @records = records.order("F_station_uuid DESC")
                        when "by_team"
                          @records = records.order("F_team_uuid DESC")
                        when "by_time"
                          @records = records.order("F_time DESC")
                        else
                          @records = records.order("F_score DESC")
                        end
          end
        else
          if current_user.permission == 1
              records = TRecordInfo.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).joins(t_record_detail_infoes: { t_detail_reason_infoes: :t_reason_info }).datetime.where('t_reason_info.F_name = ?', params[:name])
              @records = case params[:order]
                          when "by_duan"
                            @records = records.order("F_duan_uuid DESC")
                          when "by_station"
                            @records = records.order("F_station_uuid DESC")
                          when "by_team"
                            @records = records.order("F_team_uuid DESC")
                          when "by_time"
                            @records = records.order("F_time DESC")
                          else
                            @records = records.order("F_score DESC")
                          end
          elsif current_user.permission == 2
              records = TRecordInfo.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).joins(t_record_detail_infoes: { t_detail_reason_infoes: :t_reason_info }).datetime.where('t_reason_info.F_name = ?', params[:name]).where('t_record_info.F_duan_uuid=?', TDuanInfo.find_by(F_name: current_user.orgnize).F_uuid)
              @records = case params[:order]
                          when "by_duan"
                            @records = records.order("F_duan_uuid DESC")
                          when "by_station"
                            @records = records.order("F_station_uuid DESC")
                          when "by_team"
                            @records = records.order("F_team_uuid DESC")
                          when "by_time"
                            @records = records.order("F_time DESC")
                          else
                            @records = records.order("F_score DESC")
                          end
          elsif current_user.permission == 3
              records = TRecordInfo.includes(:t_user_info, :t_duan_info, :t_station_info, :t_team_info).joins(t_record_detail_infoes: { t_detail_reason_infoes: :t_reason_info }).datetime.where('t_reason_info.F_name = ?', params[:name]).where('t_record_info.F_station_uuid=?', TStationInfo.find_by(F_name: current_user.orgnize).F_uuid)
              @records = case params[:order]
                          when "by_duan"
                            @records = records.order("F_duan_uuid DESC")
                          when "by_station"
                            @records = records.order("F_station_uuid DESC")
                          when "by_team"
                            @records = records.order("F_team_uuid DESC")
                          when "by_time"
                            @records = records.order("F_time DESC")
                          else
                            @records = records.order("F_score DESC")
                          end
          end
        end
    end

    private

    def t_duan_info_params
        params.require(:t_duan_info).permit(:F_name, :F_type, :LEVEL)
    end
end
