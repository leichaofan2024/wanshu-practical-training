class TDuanInfoesController < ApplicationController

  def index

    @duans = TDuanInfo.where.not(:F_name => ["运输处","局职教基地"] )
    @duans_student =  TUserInfo.distinct(:F_id).joins(:t_duan_info).group("t_duan_info.F_name").size
    @duans_student_ck = TUserInfo.joins(:t_record_infoes).select(:F_uuid,:F_duan_uuid,:F_id).distinct(:F_id).joins(:t_duan_info).group("t_duan_info.F_name").size
  
  end



  private

  def t_duan_info_params
    params.require(:t_duan_info).permit(:F_name, :F_type, :LEVEL)
  end

end
