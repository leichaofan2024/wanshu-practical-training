class TBaogaoInfosController < ApplicationController

  def create_kuaizhao
    if params[:search].present?
      @search = TimeSearch.new(params[:search])
      student_diaoli_uuid = TVacationInfo.student_transfer(@search.date_from,@search.date_to) + TUserInfo.where("t_user_info.status=? AND t_user_info.F_type = ?","调离",0).pluck(:F_uuid)
      @student_diaoli = TUserInfo.where(:F_uuid => student_diaoli_uuid).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name,t_user_info.F_id").distinct.group("t_duan_info.F_name").count

      @station_online = TStationInfo.joins(:t_duan_info,:t_user_infoes).duan_orgnization.student_all(@search.date_from, @search.date_to).select("t_duan_info.F_name,t_station_info.F_uuid").distinct.group("t_duan_info.F_name").count
      @student_yingkao = TUserInfo.student_all(@search.date_from, @search.date_to).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name, t_user_info.F_id").distinct.group("t_duan_info.F_name").count

      @station_cankao = @search.scope_station_cankao
      student_ids = TUserInfo.student_all(@search.date_from, @search.date_to).where(:F_duan_uuid => TDuanInfo.duan_orgnization.pluck(:F_uuid)).pluck(:F_id)
      student_cankao_ids = @search.scope_student_cankao(student_ids)
      @student_cankao= TUserInfo.student_all(@search.date_from, @search.date_to).where(:F_id => student_cankao_ids).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name, t_user_info.F_id").distinct.group("t_duan_info.F_name").count
      student_dabiao = @search.scope_bg_student_dabiao(student_cankao_ids)
      dabiao_keys = []
      student_dabiao.each do |key,value|
        if value >= 3600
          dabiao_keys << key
        end
      end
      @student_dabiao = TUserInfo.student_all(@search.date_from, @search.date_to).where(:F_id => dabiao_keys).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name,t_user_info.F_id").distinct.group("t_duan_info.F_name").count

    else
      student_diaoli_uuid = TVacationInfo.student_transfer(Time.now.beginning_of_month,Time.now.end_of_month) + TUserInfo.where("t_user_info.status=? AND t_user_info.F_type = ?","调离",0).pluck(:F_uuid)
      @student_diaoli = TUserInfo.where(:F_uuid => student_diaoli_uuid).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name,t_user_info.F_id").distinct.group("t_duan_info.F_name").count

      @station_online = TStationInfo.joins(:t_duan_info,:t_user_infoes).duan_orgnization.student_all(Time.now.beginning_of_month, Time.now.end_of_month).select("t_duan_info.F_name,t_station_info.F_uuid").distinct.group("t_duan_info.F_name").count
      @student_yingkao = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name, t_user_info.F_id").distinct.group("t_duan_info.F_name").count

      @station_cankao = TStationInfo.joins(:t_duan_info,{t_user_infoes: :t_record_infoes}).duan_orgnization.student_all(Time.now.beginning_of_month, Time.now.end_of_month).datetime.select("t_duan_info.F_name,t_station_info.F_uuid").distinct.group("t_duan_info.F_name").count
      student_ids = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(:F_duan_uuid => TDuanInfo.duan_orgnization.pluck(:F_uuid)).pluck(:F_id)
      student_cankao_ids = TUserInfo.where(:F_id => student_ids).joins(:t_record_infoes).datetime.pluck(:F_id).uniq
      @student_cankao = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).where(:F_id => student_cankao_ids).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name, t_user_info.F_id").distinct.group("t_duan_info.F_name").count
      student_dabiao  = TUserInfo.where(:F_id => student_cankao_ids).joins(:t_record_infoes).datetime.group("t_user_info.F_id").sum("t_record_info.time_length")
      dabiao_keys = []
      student_dabiao.each do |key,value|
        if value >= 3600
          dabiao_keys << key
        end
      end
      @student_dabiao = TUserInfo.where(:F_id => dabiao_keys).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name,t_user_info.F_id").distinct.group("t_duan_info.F_name").count

    end

    @student_tuixiu = TUserInfo.where("t_user_info.status=? AND t_user_info.F_type = ?","退休",0).joins(:t_duan_info).duan_orgnization.select("t_duan_info.F_name,t_user_info.F_id").distinct.group("t_duan_info.F_name").count
    @kuaizhao_create_time = Time.now
    #排序
    duan_array = []
    @station_online.keys.each do |duan_name|
      one_paixu_array = []
      one_paixu_array[0] = duan_name
      one_paixu_array[1] = @student_yingkao[duan_name].to_i
      one_paixu_array[2] = (@student_dabiao[duan_name].to_f/one_paixu_array[1]*100).round(2)
      duan_array << one_paixu_array
    end
    @duan_paixu_array = duan_array.sort{|a,b| (b[2] <=> a[2]) == 0 ? (b[1] <=> a[1]) : (b[2] <=> a[2]) }

    @duan_paixu_array.each do |duan_name|
      TBaogaoInfo.create(:duan_name => duan_name[0], :online_station => @station_online[duan_name[0]], :cankao_station =>@station_cankao[duan_name[0]], :student_yingkao => duan_name[1], :student_shikao => @student_cankao[duan_name[0]], :student_dabiao_percent => duan_name[2],
       :student_diaoli =>@student_diaoli[duan_name[0]], :student_tuixiu => @student_tuixiu[duan_name[0]],:kuaizhao_create_time => @kuaizhao_create_time)
    end
    redirect_to baogao_path
  end



end
