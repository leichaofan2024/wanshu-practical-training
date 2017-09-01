class WelcomeController < ApplicationController

  def duan_ck
    @ck_duans = TDuanInfo.joins(:t_record_infoes).distinct(:F_uuid).select(:F_name).map{|a| a.F_name}
    @wk_duans = TDuanInfo.select(:F_name).map{|a| a.F_name} - @ck_duans
  end
end
