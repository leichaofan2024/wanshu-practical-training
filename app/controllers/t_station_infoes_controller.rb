class TStationInfoesController < ApplicationController


  def index
    @stations = TStationInfo.all.where(:F_duan_uuid => params[:duan])
  end



  private

  def t_station_info_params
    params.require(:t_station_info).permit(:F_name, :F_duan_uuid, :F_level, :Level)
  end
  
end
