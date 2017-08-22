class TDuanInfo < ApplicationRecord
  self.table_name = "t_duan_info"
  has_many :t_station_infoes,:class_name => "TStationInfo",:foreign_key => "F_duan_uuid"
  has_many :t_user_infoes ,:class_name => "TUserInfo" ,:foreign_key => "F_duan_uuid"
  has_many :t_record_infoes, :foreign_key => "F_duan_uuid"

  # 站段总参考人数：
  def duan_examiee_count
    m = Array.new
    self.t_record_infoes.includes(:t_user_info).each do |r|
      if r.t_user_info.present?
        m << r.t_user_info.F_id
      end
    end
    TDuanInfo.includes(:t_record_infoes,:t_user_infoes).where(:F_name => ["局职教基地","运输处"]).each do |d|
      d.t_record_infoes.includes(:t_user_info,:t_duan_info).each do |r|
        if r.t_user_info.present?
          if r.t_user_info.t_duan_info.F_name == self.F_name
            m << r.t_user_info.F_id
          end
        end
      end
    end
    n = m.uniq.count
    return n
  end

  # 站段人员的参考比例：

  def cankao_percent

    if self.duan_examiee_count > 0 && self.employee_count >0
      s = self.duan_examiee_count.to_f/self.employee_count
    else
      0
    end
  end

  # 站段人员总参考次数：
  def duan_record_count
    sum = 0
    self.t_user_infoes.each do |u|
      sum += u.t_record_infoes.count
    end
    return sum
  end

  # 站段参考人平均参考次数：
  def duan_cishu
    if self.duan_record_count ==0
      return 0
    else
      n = self.duan_record_count/self.duan_examiee_count
      return n
    end
  end

end
