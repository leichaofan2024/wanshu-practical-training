class EmployeesController < ApplicationController
  # 这段代码是，
  # 1、如果出现了站段搜索，在此基础上，进行考试状态的搜索。
  # 2、页面的初始状态是所有的站段的数据，包含未考和已考的数据（为当月考试情况），可根据需要进行搜索。
  # ****这个暂时还没有加上时间的搜索功能

  def index
    @student_ck = TUserInfo.joins(:t_record_infoes, :t_team_info).order("F_id DESC").page(params[:page]).per(20)
    @student_wk = TUserInfo.joins(:t_team_info, :t_station_info).where.not("t_user_info.F_uuid": @student_ck.ids).order("F_id DESC").page(params[:page]).per(20)
    @users = case params[:order]
    when 'by_student_wk'
      @student_wk
    when 'by_student_ck'
      @student_ck
    else
      TUserInfo.student_all.order("F_id DESC").page(params[:page]).per(20)
    end

    # @q = TUserInfo.joins(:t_station_info, :t_team_info).ransack(params[:q])
    # @users = @q.result.order("F_id DESC").page(params[:page]).per(20)
    if params[:registration_id].present?
      @users = @users.where('t_station_info.F_name' => params[:registration_id])
    end
  end
end
