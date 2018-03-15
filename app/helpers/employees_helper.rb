module EmployeesHelper

  def employe_user(duan)
     @user = TUserInfo.student_all.joins(:t_duan_info).where("t_duan_info.F_name = ? ", duan).pluck("t_user_info.F_id").uniq.size
     # @duan = TDuanInfo.where("t_duan_info.F_name = ? ", duan).joins(:t_user_infoes).where("t_user_info.F_id": @user).select("t_duan_info.F_name","t_user_info.F_id").distinct.count
  end

  def employe_record(duan)
    @user = TUserInfo.student_all.joins(:t_duan_info, :t_record_infoes).where("t_duan_info.F_name = ? ", duan).where("t_record_info.F_time BETWEEN ? AND ?", '2018-02-01','2018-02-28').pluck("t_user_info.F_id").uniq.size

    # @duan = TDuanInfo.joins(:t_user_infoes).where("t_user_info.F_uuid": @user).group("t_duan_info.F_name").count
  end

  def employe_transfer(duan,status)
    @user = TUserInfo.joins(:t_duan_info).where("t_duan_info.F_name = ? ", duan).where(:status => status).pluck("t_user_info.F_uuid").uniq.size
  end


end
