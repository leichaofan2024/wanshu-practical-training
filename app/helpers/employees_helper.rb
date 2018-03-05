module EmployeesHelper

  def employe_user(duan)
     @user = TUserInfo.joins(:t_duan_info).where("t_duan_info.F_name = ? ", duan).student_all.pluck("t_user_info.F_uuid").uniq
     @duan = TDuanInfo.joins(:t_user_infoes).where("t_user_info.F_uuid": @user).group("t_duan_info.F_name").count
  end

  def employe_record(duan)
    @user = TUserInfo.joins(:t_duan_info, :t_record_infoes).where("t_duan_info.F_name = ? ", duan).student_all.where("t_record_info.F_time BETWEEN ? AND ?", '2017-1-1','2018-1-1').pluck("t_user_info.F_uuid").uniq
    @duan = TDuanInfo.joins(:t_user_infoes).where("t_user_info.F_uuid": @user).group("t_duan_info.F_name").count
  end

  def employe_transfer(duan,status)
    @user = TUserInfo.joins(:t_duan_info).where("t_duan_info.F_name = ? ", duan).where(:status => status).pluck("t_user_info.F_uuid").uniq
    @duan = TDuanInfo.joins(:t_user_infoes).where("t_user_info.F_uuid": @user).group("t_duan_info.F_name").count
  end

  def employe_retire(duan)

  end

end
