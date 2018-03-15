module TDuanInfoesHelper
  def duan_student_ck(duan)
    m = TUserInfo.where(:F_duan_uuid => duan.F_uuid).joins(:t_record_infoes).select(:F_id).distinct.count
  end

end
