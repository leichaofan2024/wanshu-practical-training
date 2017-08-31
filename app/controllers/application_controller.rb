class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method [:duan,:duan_z,:duan_cw,:duan_ju,:duan_ck,:station,:station_ck,:team,:team_ju,:team_ck,:student,:student_ck, :teacher ,:program_ck,
                 :score_90,:score_80,:score_60,:score_60_below,:program_type_1,:program_type_2,:program_type_3,:program_type_4,:reason_hot_all]
  def duan
    m = TDuanInfo.includes(:t_record_infoes).where.not("F_name= ? || F_name= ?", "局职教基地", "运输处")
  end

  def duan_ck
    m = Array.new
    duan.each do |d|
      if d.t_record_infoes.present?
        m << d
      end
    end
    return m
  end

  def duan_z
    m = TDuanInfo.where(F_type: 2)
  end

  def duan_cw
    m = TDuanInfo.where(F_type: 1)
  end

  def duan_ju
    m = TDuanInfo.where("F_name = ? || F_name= ?", "局职教基地", "运输处")
  end

  def station
    m = TStationInfo.includes(:t_record_infoes).where.not("F_duan_uuid = ? || F_duan_uuid = ? " , duan_ju.first.F_uuid,duan_ju.last.F_uuid)
  end

  def station_ju
    m = TStationInfo.includes(:t_record_infoes).where("F_duan_uuid = ? || F_duan_uuid = ? " , duan_ju.first.F_uuid,duan_ju.last.F_uuid)
  end

  def station_ck
    m= Array.new
    station.each do |s|
      if s.t_record_infoes.present?
        m<< s
      end
    end
    return m
  end

  def team
    m = TTeamInfo.includes(:t_record_infoes,:t_station_info).all - team_ju
  end

  def team_ju
    m = Array.new
    station_ju.each do |s|
      m << s.t_team_infoes
    end
    return m
  end


  def team_ck
    m = Array.new
    team.each do |t|
      if t.t_record_infoes.present?
        m<< t
      end
    end
    return m
  end

  def student
    m = TUserInfo.includes(:t_record_infoes).where(:F_type => 0)
  end

  def student_ck
    m = student.select{|s| s.t_record_infoes.present?}

  end

  def teacher
    m = TUserInfo.where(:F_type => 1)
  end

  def program_ck
    m = Array.new
    TRecordDetailInfo.includes(:t_program_info).all.each do |t|
      m << t.t_program_info
    end
    return m.uniq
  end

  def score_90
    m = TRecordInfo.where("F_score >= ?", 90)
  end

  def score_80
    m = TRecordInfo.where("F_score >= ? AND F_score<? ", 80,90)
  end

  def score_60
    m = TRecordInfo.where("F_score >= ? AND F_score<? ", 60,80)
  end

  def score_60_below
    m = TRecordInfo.where("F_score< ? ", 60)
  end

  def program_type_1
    m = TRecordDetailInfo.record_type_1
  end

  def program_type_2
    m = TRecordDetailInfo.record_type_2
  end

  def program_type_3
    m = TRecordDetailInfo.record_type_3
  end

  def program_type_4
    m = TRecordDetailInfo.record_type_4
  end

  def reason_hot_all
    m = TReasonInfo.all.map{|r| [r.F_name,r.t_detail_reason_infoes.size]}.sort_by{|a| a.second}.map{|b| b.first}.reverse
  end

end
