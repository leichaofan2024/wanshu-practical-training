class TDuanInfoesController < ApplicationController

  def index
    @duans = TDuanInfo.where.not(:F_name => ["运输处","局职教基地"] )
    # @records = TRecordInfo.pluck(:F_user_uuid)
    # @users = TUserInfo.select{|u| @records.include?(u.F_uuid)}

  end



  private

  def t_duan_info_params
    params.require(:t_duan_info).permit(:F_name, :F_type, :LEVEL)
  end

end
