class TDuanInfoesController < ApplicationController

  def index
  end 



  private

  def t_duan_info_params
    params.require(:t_duan_info).permit(:F_name, :F_type, :LEVEL)
  end

end
