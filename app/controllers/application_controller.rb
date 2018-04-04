class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :authenticate_user!
    helper_method [:duan, :duan_z, :duan_cw, :duan_ju, :duan_ck_count, :station, :station_ck_count, :team, :team_ju, :team_ck_count, :student_wk_count, :students, :student_ck_count, :student_ck_counts, :teacher, :program_ck_count,
                   :score_90, :score_80, :score_60, :score_60_below, :program_type_percent, :reason_hot_all,:student_dabiao_count]

    def all_browsed?
      call_board_ids = current_user.browses.pluck(:call_board_id)
      if current_user.permission == 1 || current_user.permission ==2
        call_boards = CallBoard.where(user_id: User.where(:permission => 1).ids)
        if (call_boards.ids - call_board_ids).present?
          flash[:alert] = "您有新公告未读！请前往查看～"
        end
      else current_user.permission ==3
        duan = TStationInfo.find_by(:F_name => current_user.orgnize).t_duan_info
        call_boards_1 = CallBoard.where(user_id: User.where(:permission => 1).ids).ids
        call_boards_2 = User.find_by(:orgnize => duan.F_name).call_boards.ids
        call_boards = call_boards_1 + call_boards_2
        if (call_boards - call_board_ids).present?
          flash[:alert] = "您有新公告未读！请前往查看～"
        end
      end

    end
    def duan
        m = TDuanInfo.where.not('F_name= ? || F_name= ?', '局职教基地', '运输处').count
    end

# 这个是第一个卡片
    def duan_ck_count
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_duan.select('t_duan_info.F_uuid').distinct.count
        else
            m = TDuanInfo.duan_orgnization.joins(t_user_infoes: :t_record_infoes).student_all(Time.now.beginning_of_month, Time.now.end_of_month).datetime.distinct.count
      end
    end

    def duan_z
        m = TDuanInfo.where(F_type: 2)
    end

    def duan_cw
        m = TDuanInfo.where(F_type: 1)
    end

    def duan_ju
        m = TDuanInfo.duan_zhijiao
    end

    def station
      if current_user.permission == 1
        m = TStationInfo.station_orgnization.joins(:t_user_infoes).student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct.count
      elsif current_user.permission == 2
        m= TStationInfo.joins(:t_user_infoes).student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(F_duan_uuid: TDuanInfo.find_by(:F_name => current_user.orgnize).F_uuid).distinct.count
      end

    end

    def station_ju
        m = TStationInfo.includes(:t_record_infoes).station_zhijiao
    end
# 这是第二个卡片
    def station_ck_count
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_station.distinct.count
        else
            m = TStationInfo.station_orgnization.joins(t_user_infoes: :t_record_infoes).student_all(Time.now.beginning_of_month, Time.now.end_of_month).datetime.distinct.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_station.joins(:t_duan_info).where("t_duan_info.F_name=?", current_user.orgnize).distinct.count
        else
            m = TStationInfo.station_orgnization.joins(:t_duan_info,t_user_infoes: :t_record_infoes).student_all(Time.now.beginning_of_month, Time.now.end_of_month).where("t_duan_info.F_name=?", current_user.orgnize).datetime.distinct.count
        end
      end
    end

    def team
      if current_user.permission == 1
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).duan_orgnization.student_all(@search.date_from, @search.date_to).distinct.count
        else
          m = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).duan_orgnization.student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name= ?",current_user.orgnize).student_all(@search.date_from, @search.date_to).distinct.count
        else
          m = TTeamInfo.joins({t_station_info: :t_duan_info},:t_user_infoes).where("t_duan_info.F_name= ?",current_user.orgnize).student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct.count
        end
      elsif current_user.permission ==3
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = TTeamInfo.joins(:t_station_info,:t_user_infoes).where("t_station_info.F_name": current_user.orgnize).student_all(@search.date_from, @search.date_to).distinct.count
        else
          m = TTeamInfo.joins(:t_station_info,:t_user_infoes).where("t_station_info.F_name": current_user.orgnize).student_all(Time.now.beginning_of_month, Time.now.end_of_month).distinct.count
        end
      end

    end
# 这是第三个卡片
    def team_ck_count
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_team.distinct.count
        else
            m = TTeamInfo.team_orgnization.joins(t_user_infoes: :t_record_infoes).student_all(Time.now.beginning_of_month, Time.now.end_of_month).datetime.distinct.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_team_duan(current_user.orgnize).distinct.count
        else
            m = TTeamInfo.joins(t_station_info: :t_duan_info).where("t_duan_info.F_name= ?",current_user.orgnize).joins(t_user_infoes: :t_record_infoes).student_all(Time.now.beginning_of_month, Time.now.end_of_month).datetime.distinct.count
        end
      elsif current_user.permission ==3
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m= @search.scope_team_station(current_user.orgnize).distinct.count
        else
          m = TTeamInfo.joins(:t_station_info,t_user_infoes: :t_record_infoes).where("t_station_info.F_name": current_user.orgnize).student_all(Time.now.beginning_of_month, Time.now.end_of_month).datetime.distinct.count
        end
      end
    end

    def students
      if params[:search].present?
        @search = TimeSearch.new(params[:search])
        if current_user.permission == 1
          m = TUserInfo.student_all(@search.date_from, @search.date_to).where.not(F_duan_uuid: ["74708afh145a11e6ad9d001ec9b3cd0c", "74708bnv145a11e6ad9d001ec9b3cd0c"]).select(:F_id).distinct.count
        elsif current_user.permission == 2
          m = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_duan_info).where("t_duan_info.F_name= ?",current_user.orgnize).select("t_user_info.F_id").distinct.count
        elsif current_user.permission == 3
          m = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_station_info).where("t_station_info.F_name=?", current_user.orgnize).select("t_user_info.F_id").distinct.count
        end
      else 
        if current_user.permission == 1
          m = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where.not(F_duan_uuid: ["74708afh145a11e6ad9d001ec9b3cd0c", "74708bnv145a11e6ad9d001ec9b3cd0c"]).select(:F_id).distinct.count
        elsif current_user.permission == 2
          m = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info).where("t_duan_info.F_name= ?",current_user.orgnize).select("t_user_info.F_id").distinct.count
        elsif current_user.permission == 3
          m = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_station_info).where("t_station_info.F_name=?", current_user.orgnize).select("t_user_info.F_id").distinct.count
        end
      end
    end

    def student_ck_counts
      if current_user.permission == 1
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = @search.scope_student.select("t_user_info.F_id").distinct.count
        else
          m = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where.not(F_duan_uuid: ["74708afh145a11e6ad9d001ec9b3cd0c", "74708bnv145a11e6ad9d001ec9b3cd0c"]).joins(:t_record_infoes).datetime.select("t_user_info.F_id").distinct.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = @search.scope_student.joins(:t_duan_info).where("t_duan_info.F_name= ? ", current_user.orgnize).select("t_user_info.F_id").distinct.count
        else
          m = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info,:t_record_infoes).where("t_duan_info.F_name= ?", current_user.orgnize).datetime.select("t_user_info.F_id").distinct.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = @search.scope_student.joins(:t_station_info).where("t_station_info.F_name= ? ", current_user.orgnize).select("t_user_info.F_id").distinct.count
        else
          m = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_station_info,:t_record_infoes).datetime.where("t_station_info.F_name= ?", current_user.orgnize).select("t_user_info.F_id").distinct.count
        end
      end
    end

    def student_wk_count
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = TUserInfo.student_all(@search.date_from, @search.date_to).where.not(F_duan_uuid: ["74708afh145a11e6ad9d001ec9b3cd0c", "74708bnv145a11e6ad9d001ec9b3cd0c"]).select("t_user_info.F_id").distinct.count - @search.scope_student_k.select("t_user_info.F_id").distinct.count
        else
            m = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where.not(F_duan_uuid: ["74708afh145a11e6ad9d001ec9b3cd0c", "74708bnv145a11e6ad9d001ec9b3cd0c"]).select("t_user_info.F_id").distinct.count - TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where.not(F_duan_uuid: ["74708afh145a11e6ad9d001ec9b3cd0c", "74708bnv145a11e6ad9d001ec9b3cd0c"]).joins(:t_record_infoes).datetime.select("t_user_info.F_id").distinct.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).select("t_user_info.F_id").distinct.count - @search.scope_student_k.joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).select("t_user_info.F_id").distinct.count
        else
            m = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).select("t_user_info.F_id").distinct.count - TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info,:t_record_infoes).datetime.where("t_duan_info.F_name= ?", current_user.orgnize).select("t_user_info.F_id").distinct.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).select("t_user_info.F_id").distinct.count - @search.scope_student_k.joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).select("t_user_info.F_id").distinct.count
        else
            m = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).select("t_user_info.F_id").distinct.count - TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_station_info,:t_record_infoes).datetime.where("t_station_info.F_name= ?", current_user.orgnize).select("t_user_info.F_id").distinct.count
        end
      end
      s = {}
      s['未考人数'] = m
      @weikao = { name: '未考人数', value: s['未考人数'] }
      gon.weikao = @weikao
    end

    def student_ck_count
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_student_k.select("t_user_info.F_id").distinct.count
        else
            m = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where.not(F_duan_uuid: ["74708afh145a11e6ad9d001ec9b3cd0c", "74708bnv145a11e6ad9d001ec9b3cd0c"]).joins(:t_record_infoes).datetime.select("t_user_info.F_id").distinct.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = @search.scope_student_k.joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).select("t_user_info.F_id").distinct.count
        else
          m = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info,:t_record_infoes).datetime.where("t_duan_info.F_name= ?", current_user.orgnize).select("t_user_info.F_id").distinct.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = @search.scope_student_k.joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).select("t_user_info.F_id").distinct.count
        else
          m = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_station_info,:t_record_infoes).datetime.where("t_station_info.F_name= ?", current_user.orgnize).select("t_user_info.F_id").distinct.count
        end
      end
        result = {}
        result['实考人数'] = m
        @shikao = { name: '实考人数', value: result['实考人数'] }
        gon.shikao = @shikao
    end


    def student_dabiao_count
      if current_user.permission == 1
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          sum = TUserInfo.student_all(@search.date_from, @search.date_to).where.not(F_duan_uuid: ["74708afh145a11e6ad9d001ec9b3cd0c", "74708bnv145a11e6ad9d001ec9b3cd0c"]).select(:F_id).distinct.count
          n = @search.scope_student_dabiao1
          user_f_id= Array.new
          n.each do |key,value|
            if value>= 3600
              user_f_id << key
            end
          end
          x = user_f_id.size
        else
          sum = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where.not(F_duan_uuid: ["74708afh145a11e6ad9d001ec9b3cd0c", "74708bnv145a11e6ad9d001ec9b3cd0c"]).select(:F_id).distinct.count
          n = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where.not(F_duan_uuid: ["74708afh145a11e6ad9d001ec9b3cd0c", "74708bnv145a11e6ad9d001ec9b3cd0c"]).joins(:t_record_infoes).datetime.group("t_user_info.F_id").sum("t_record_info.time_length")
          user_f_id= Array.new
          n.each do |key,value|
            if value>= 3600
              user_f_id << key
            end
          end
          x = user_f_id.size
        end
        y = sum - x
      elsif current_user.permission == 2
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          sum = TUserInfo.student_all(@search.date_from, @search.date_to).where(:F_duan_uuid => TDuanInfo.find_by(:F_name => current_user.orgnize).F_uuid).select(:F_id).distinct.count
          n = @search.scope_student_dabiao2(current_user)
          user_f_id= Array.new
          n.each do |key,value|
            if value>= 3600
              user_f_id << key
            end
          end
          x = user_f_id.size
        else
          sum = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(:F_duan_uuid => TDuanInfo.find_by(:F_name => current_user.orgnize).F_uuid).select(:F_id).distinct.count
          n = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info,:t_record_infoes).datetime.where("t_duan_info.F_name= ?", current_user.orgnize).group("t_user_info.F_id").sum("t_record_info.time_length")
          user_f_id= Array.new
          n.each do |key,value|
            if value>= 3600
              user_f_id << key
            end
          end
          x = user_f_id.size
        end
        y = sum - x
      elsif current_user.permission == 3

        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          sum = TUserInfo.student_all(@search.date_from, @search.date_to).where(:F_station_uuid => TStationInfo.find_by(:F_name => current_user.orgnize).F_uuid).select(:F_id).distinct.count
          n = @search.scope_student_dabiao3(current_user)
          user_f_id= Array.new
          n.each do |key,value|
            if value>= 3600
              user_f_id << key
            end
          end
          x = user_f_id.size
        else
          sum = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(:F_station_uuid => TStationInfo.find_by(:F_name => current_user.orgnize).F_uuid).select(:F_id).distinct.count
          n = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_station_info,:t_record_infoes).datetime.where("t_station_info.F_name= ?", current_user.orgnize).group("t_user_info.F_id").sum("t_record_info.time_length")
          user_f_id= Array.new
          n.each do |key,value|
            if value>= 3600
              user_f_id << key
            end
          end
          x = user_f_id.size
        end
        y = sum - x
      end
        result_dabiao = {}
        result_weidabiao = {}
        result_dabiao['达标人数'] = x
        result_weidabiao['未达标人数'] = y
        gon.dabiao = { name: '达标人数', value: result_dabiao['达标人数'] }
        gon.weidabiao = { name: '未达标人数', value: result_weidabiao['未达标人数'] }
    end

    def teacher
        m = TUserInfo.where(F_type: 1)
    end

    def program_ck_count
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_program
        else
            m = TProgramInfo.joins(:t_record_infoes).datetime.distinct.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = @search.scope_program_duan.where("t_duan_info.F_name= ?", current_user.orgnize).distinct.count
        else
          m = TProgramInfo.joins(t_record_infoes: :t_duan_info).datetime.where("t_duan_info.F_name= ?", current_user.orgnize).distinct.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
          @search = TimeSearch.new(params[:search])
          m = @search.scope_program_station.where("t_station_info.F_name= ?", current_user.orgnize).distinct.count
        else
          m = TProgramInfo.joins(t_record_infoes: :t_station_info).datetime.where("t_station_info.F_name= ?", current_user.orgnize).distinct.count
        end
      end
    end

    def score_90
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ?', 90).count
        else
            m = TRecordInfo.where('F_score >= ?', 90).datetime.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ?', 90).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score >= ?', 90).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).datetime.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ?', 90).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score >= ?', 90).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).datetime.count
        end
      end
        result = {}
        result['90分以上'] = m
        @nine = { name: '90分以上', value: result['90分以上'] }
        gon.nine = @nine
    end

    def score_80
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ? AND F_score<? ', 80, 90).count
        else
            m = TRecordInfo.where('F_score >= ? AND F_score<? ', 80, 90).datetime.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ? AND F_score<? ', 80, 90).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score >= ? AND F_score<? ', 80, 90).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).datetime.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ? AND F_score<? ', 80, 90).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score >= ? AND F_score<? ', 80, 90).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).datetime.count
        end
      end
        result = {}
        result['80分-90分'] = m
        @eight = { name: '80分-90分', value: result['80分-90分'] }
        gon.eight = @eight
    end

    def score_60
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ? AND F_score<? ', 60, 80).count
        else
            m = TRecordInfo.where('F_score >= ? AND F_score<? ', 60, 80).datetime.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ? AND F_score<? ', 60, 80).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score >= ? AND F_score<? ', 60, 80).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).datetime.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score >= ? AND F_score<? ', 60, 80).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score >= ? AND F_score<? ', 60, 80).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).datetime.count
        end
      end

        result = {}
        result['60分-80分'] = m
        @six = { name: '60分-80分', value: result['60分-80分'] }
        gon.six = @six
    end

    def score_60_below
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score< ? ', 60).count
        else
            m = TRecordInfo.where('F_score< ? ', 60).datetime.count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score< ? ', 60).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score< ? ', 60).joins(:t_duan_info).where("t_duan_info.F_name= ?", current_user.orgnize).datetime.count
        end
      elsif current_user.permission == 3
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_score.where('F_score< ? ', 60).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).count
        else
            m = TRecordInfo.where('F_score< ? ', 60).joins(:t_station_info).where("t_station_info.F_name= ?", current_user.orgnize).datetime.count
        end
      end
        result = {}
        result['60分以下'] = m
        @below = { name: '60分以下', value: result['60分以下'] }
        gon.below = @below
    end

    def program_type_percent
      if current_user.permission == 1
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_program_type
        else
            m = TProgramTypeInfo.joins(t_program_infoes: :t_record_infoes).datetime.group(:F_name).count
        end
      elsif current_user.permission == 2
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_program_type_duan.where("t_record_info.F_duan_uuid=?", TDuanInfo.find_by(:F_name => current_user.orgnize).F_uuid).group(:F_name).count
        else
            m = TProgramTypeInfo.joins(t_program_infoes: :t_record_infoes).where("t_record_info.F_duan_uuid=?", TDuanInfo.find_by(:F_name => current_user.orgnize).F_uuid).datetime.group("t_program_type_info.F_name").count
        end
      elsif current_user.permission == 3
        if params[:search].present?
            @search = TimeSearch.new(params[:search])
            m = @search.scope_program_type_station.where("t_record_info.F_station_uuid=?", TStationInfo.find_by(:F_name => current_user.orgnize).F_uuid).group(:F_name).count
        else
            m = TProgramTypeInfo.joins(t_program_infoes: :t_record_infoes).where("t_record_info.F_station_uuid=?", TStationInfo.find_by(:F_name => current_user.orgnize).F_uuid).datetime.group("t_program_type_info.F_name").count
        end
      end

        @yjcz = { name: '应急处置', value: m['应急处置'] }
        gon.yj = @yjcz
        @zcjf = { name: '正常接发车办理科目', value: m['正常接发车办理科目'] }
        gon.zc = @zcjf
        @fzcfche = { name: '非正常发车办理科目', value: m['非正常发车办理科目'] }
        gon.fzcfche = @fzcfche
        @fzcjche = { name: '非正常接车办理科目', value: m['非正常接车办理科目'] }
        gon.fzcjche = @fzcjche
    end

    def reason_hot_all
      if current_user.permission == 1
        if params[:search].present?
            # m = TReasonInfo.joins(:t_detail_reason_infoes).group(:F_name).size.sort { |a, b| b[1] <=> a[1] }
            @search = TimeSearch.new(params[:search])
            n = @search.scope_reason_hot.group(:F_name).size.sort_by { |_key, value| value }.reverse
            m = n.first(8).to_h
            other_value= n.to_h.values.sum - n.first(8).to_h.values.sum
        else
            n = TReasonInfo.joins(:t_detail_reason_infoes).datetime1.group(:F_name).size.sort_by { |_key, value| value }.reverse
            m = n.first(8).to_h
            other_value= n.to_h.values.sum - n.first(8).to_h.values.sum
        end
      elsif current_user.permission == 2
        record = TRecordDetailInfo.joins(t_record_info: :t_duan_info).where("t_duan_info.F_name=?", current_user.orgnize)
        if params[:search].present?
          # m = TReasonInfo.joins(:t_detail_reason_infoes).group(:F_name).size.sort { |a, b| b[1] <=> a[1] }
          @search = TimeSearch.new(params[:search])
          n = @search.scope_reason_hot1(current_user.orgnize).group("t_reason_info.F_name").count.sort_by { |_key, value| value }.reverse
          m = n.first(8).to_h
          other_value = n.to_h.values.sum - n.first(8).to_h.values.sum
        else
          n = TReasonInfo.joins(:t_record_detail_infoes).where("t_record_detail_info.F_uuid": record.ids).datetime1.group("t_reason_info.F_name").count.sort_by { |_key, value| value }.reverse
          m = n.first(8).to_h
          other_value = n.to_h.values.sum - n.first(8).to_h.values.sum
        end
      elsif current_user.permission == 3
        record = TRecordDetailInfo.joins(t_record_info: :t_station_info).where("t_station_info.F_name=?", current_user.orgnize)
        if params[:search].present?
          # m = TReasonInfo.joins(:t_detail_reason_infoes).group(:F_name).size.sort { |a, b| b[1] <=> a[1] }
          @search = TimeSearch.new(params[:search])
          n = @search.scope_reason_hot2(current_user.orgnize).group("t_reason_info.F_name").count.sort_by { |_key, value| value }.reverse
          m = n.first(8).to_h
          other_value = n.to_h.values.sum - n.first(8).to_h.values.sum
        else
          n = TReasonInfo.joins(:t_record_detail_infoes).where("t_record_detail_info.F_uuid": record.ids).datetime1.group("t_reason_info.F_name").count.sort_by { |_key, value| value }.reverse
          m = n.first(8).to_h
          other_value = n.to_h.values.sum - n.first(8).to_h.values.sum
        end
      end
        gon.reason_key8 = m.keys+["其他"]
        @a = { name: m.keys[0], value: m.values[0] }
        gon.a = @a
        @b = { name: m.keys[1], value: m.values[1]}
        gon.b = @b
        @c = { name: m.keys[2], value: m.values[2] }
        gon.c = @c
        @d = { name: m.keys[3], value: m.values[3] }
        gon.d = @d
        @e = { name: m.keys[4], value: m.values[4] }
        gon.e = @e
        @f = { name: m.keys[5], value: m.values[5]}
        gon.f = @f
        @g = { name: m.keys[6], value: m.values[6] }
        gon.g = @g
        @h = { name: m.keys[7], value: m.values[7] }
        gon.h = @h
        @i = { name: "其他", value: other_value }
        gon.i = @i
    end
end
