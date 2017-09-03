class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method [:duan,:duan_z,:duan_cw,:duan_ju,:duan_ck_count,:station,:station_ck_count,:team,:team_ju,:team_ck_count,:student,:student_ck_count, :teacher ,:program_ck_count,
                 :score_90,:score_80,:score_60,:score_60_below,:program_type_percent,:reason_hot_all]
  def duan
    m = TDuanInfo.where.not("F_name= ? || F_name= ?", "局职教基地", "运输处").count
  end

  def duan_ck_count
    m = TRecordInfo.select("F_duan_uuid").group("F_duan_uuid").size.count - 2
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
    m = TStationInfo.where.not("F_duan_uuid = ? || F_duan_uuid = ? " , duan_ju.first.F_uuid,duan_ju.last.F_uuid).count
  end

  def station_ju
    m = TStationInfo.includes(:t_record_infoes).where("F_duan_uuid = ? || F_duan_uuid = ? " , duan_ju.first.F_uuid,duan_ju.last.F_uuid)
  end

  def station_ck_count
    m = TStationInfo.joins(:t_record_infoes).select(:F_uuid).distinct.count
  end

  def team
    m = TDuanInfo.where.not(:F_name => ["运输处", "局职教基地"]).joins(t_station_infoes: :t_team_infoes).count
  end

  def team_ck_count
    m = TTeamInfo.joins(t_station_info: :t_duan_info).where.not("t_duan_info.F_name = '运输处' OR t_duan_info.F_name = '局职教基地'").joins(:t_record_infoes).distinct.count
  end

  def student
    m = TUserInfo.where(:F_type => 0).count
  end

  def student_ck_count
    m = TUserInfo.where(:F_type => 0).joins(:t_record_infoes).select(:F_id).distinct.count

  end

  def teacher
    m = TUserInfo.where(:F_type => 1)
  end

  def program_ck_count
    m = TProgramInfo.joins(:t_record_detail_infoes).distinct.count
  end

  def score_90
    m = TRecordInfo.where("F_score >= ?", 90).count
  end

  def score_80
    m = TRecordInfo.where("F_score >= ? AND F_score<? ", 80,90).count
  end

  def score_60
    m = TRecordInfo.where("F_score >= ? AND F_score<? ", 60,80).count
  end

  def score_60_below
    m = TRecordInfo.where("F_score< ? ", 60).count
  end

  def program_type_percent
    m = TProgramTypeInfo.joins(t_program_infoes: :t_record_detail_infoes).group(:F_name).size
  end


  def reason_hot_all
    m = TReasonInfo.joins(:t_detail_reason_infoes).group(:F_name).size.sort{|a,b| b[1]<=>a[1]}
    # m = TReasonInfo.joins(:t_detail_reason_infoes).group(:F_name).size.sort_by{|key,value| value}
  end

end
