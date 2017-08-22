class TDuanInfoesController < ApplicationController


  def index
    # 站段名片展示
    @duan_z = TDuanInfo.includes(:t_user_infoes, :t_station_infoes).all.where(:F_type => 2)
    @duan_cw = TDuanInfo.includes(:t_user_infoes,:t_station_infoes).all.where("F_type = ? AND F_name != ?", 1,"局职教基地").where("F_name != ?","运输处")
    @duan_zj = TDuanInfo.includes(:t_user_infoes,:t_station_infoes).all.where(:F_name => ["局职教基地","运输处"])

    # 参考比例：
    @duan_paixu = TDuanInfo.includes(:t_user_infoes,:t_record_infoes).where.not("F_name = ? or F_name = ? ", "局职教基地", "运输处").map{|d| [d.F_name,d.cankao_percent]}.sort_by{|t| t.second}.reverse
    @duan_names = @duan_paixu.map{|d| d.first}
    @ck_percents= @duan_paixu.map{|t|  (t.second*100).to_i}

    # 平均参考次数
    @duan_cishu_paixu = TDuanInfo.includes(:t_user_infoes,:t_record_infoes).where.not("F_name = ? or F_name = ?", "局职教基地", "运输处").map{|d| [d.F_name, d.duan_cishu]}.sort_by{|t| t.second}.reverse
    @duan_cishu_names = @duan_cishu_paixu.map{|d| d.first}
    @duan_cishues     = @duan_cishu_paixu.map{|d| d.second}
  end


  private

  def t_duan_info_params
    params.require(:t_duan_info).permit(:F_name, :F_type, :LEVEL)
  end

end
