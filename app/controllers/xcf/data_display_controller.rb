class Xcf::DataDisplayController < ApplicationController
  def general_overview
    if params[:search].present?
      @search = TimeSearch.new(params[:search])
      @records_all = XcfRecordInfo.where("xcf_record_infos.F_begin_time between ? and ?",@search.date_from+8.hours,@search.date_to+8.hours)
    else
      @records_all = XcfRecordInfo.xcf_datetime
    end

      #下面会用到的几个查询：
      a_record_join_user = @records_all.joins(:xcf_user_infos)
      a_record_join_user_join_duan = @records_all.joins(xcf_user_infos: :t_duan_info).select("xcf_user_infos.F_id,t_duan_info.F_name").distinct
      a_record_details  = XcfRecordDetailInfo.where(F_record_uuid: @records_all.pluck(:F_uuid))
      a_detail_reasons = XcfDetailReasonInfo.where(:F_record_detail_uuid => a_record_details.pluck(:F_uuid))
      # 第一部分：
      # 总人数各站段哈希
      @student_all = a_record_join_user_join_duan.group("t_duan_info.F_name").count

      @record_details = a_record_details.group_by{|rd| rd.F_record_uuid}

      detail_hege = Array.new
      record_hege = Array.new
      @record_details.each do |record_uuid,record_details|
        record_details.each do |record_detail|
          if record_detail.F_score >=80
            detail_hege << 1
          else
            detail_hege << 0
          end
        end
        if !detail_hege.include?(0)
          record_hege << record_uuid
        end
      end

      @record_hege = XcfRecordInfo.where(F_uuid: record_hege)
      # 合格人数各站段哈希
      @student_hege = {}
      @student_buhege = {}
      student_hege = @record_hege.joins(xcf_user_infos: :t_duan_info).select("xcf_user_infos.F_id,t_duan_info.F_name").distinct.group("t_duan_info.F_name").count
      @student_all.keys.each do |key|
        if student_hege.keys.include?(key)
          @student_hege[key] = student_hege[key]
        else
          @student_hege[key] = 0
        end
        @student_buhege[key] = @student_all[key] - @student_hege[key]
      end
      # 合格人数比例各站段哈希
      @student_hege_bl = Hash.new
      @student_all.keys.each do |key|
        if @student_hege[key].present?
          @student_hege_bl[key]= (@student_hege[key].to_f/@student_all[key]).round(3)*100
        else
          @student_hege_bl[key] = 0.to_f
        end
      end



     # 第二部分：
     a_user_record_hash = a_record_join_user.select("xcf_record_infos.F_uuid,xcf_user_infos.F_id").group_by{|u| u.F_id}
     if a_user_record_hash.present?
       a_user_record_hash.each do |f_id,records|
         n = 1
         m = 1
         records.each do |record|
           XcfRecordDetailInfo.where(:F_record_uuid => record.F_uuid).each do |detail|
             m = m + 1
             if detail.F_score >= 80
               n = n+1
             end
           end
         end

         #每个考生的考题达标率：
         a_user_record_hash[f_id] = (n.to_f/m).round(3)*100
       end
     end
     #饼图考题达标率占比：
     @dabiao_100 = a_user_record_hash.values.map{|x| x if x == 100}.compact.size
     @dabiao_80 = a_user_record_hash.values.map{|x| x if x >= 80 && x < 100}.compact.size
     @dabiao_60 = a_user_record_hash.values.map{|x| x if x >= 60 && x < 80}.compact.size
     @dabiao_60_below = a_user_record_hash.values.map{|x| x if x < 60}.compact.size
     #各站段考题达标率占比：
     @dabiao_duan_100 = Hash.new
     @dabiao_duan_80 = Hash.new
     @dabiao_duan_60 = Hash.new
     @dabiao_duan_60_below = Hash.new
     a_record_join_user_join_duan.group_by{|x| x.F_name}.each do |duan_name, users|
       a = 0
       b = 0
       c = 0
       d = 0
       users.each do |user|
         if a_user_record_hash[user.F_id] == 100
           a = a + 1
         elsif a_user_record_hash[user.F_id] < 100 && a_user_record_hash[user.F_id] >= 80
           b = b + 1
         elsif a_user_record_hash[user.F_id] < 80 && a_user_record_hash[user.F_id] >= 60
           c = c + 1
         elsif a_user_record_hash[user.F_id] < 60
           d = d + 1
         end
       end
       @dabiao_duan_100[duan_name] = a
       @dabiao_duan_80[duan_name] = b
       @dabiao_duan_60[duan_name] = c
       @dabiao_duan_60_below[duan_name] = d
     end

     #第三部分
     #每个考核项点的出现频次，倒叙排列:
     a_record_detail_joins_program = a_record_details.joins(:xcf_program_infos)
     @program_record_detail_count = a_record_detail_joins_program.group("xcf_program_infos.F_name").count.sort{|a,b| b[1]<=>a[1]}
     #每个考核项点的平均成绩:
     @program_record_detail_average = a_record_detail_joins_program.group("xcf_program_infos.F_name").average("xcf_record_detail_infos.F_score")

     #第四部分:
     #扣分项点出现频次，倒叙排列:
     @detail_reasons_count = a_detail_reasons.joins(:xcf_reason_infos).group("xcf_reason_infos.F_name").count.sort{|a,b| b[1]<=>a[1]}


     #第一个饼图:
     gon.hege = {name: "合格人数", value: @student_hege.values.sum}
     gon.buhege = {name: "不合格人数", value: (@student_all.values.sum -@student_hege.values.sum)}
     # gon.hege = {name: "合格人数", value: 70}
     # gon.buhege = {name: "不合格人数", value: 24}
     #柱状图:
     gon.hege_duan_key = @student_all.keys
     gon.hege_duan_value = @student_hege.values
     gon.buhege_duan_value = @student_buhege.values
     # gon.hege_duan_key = TDuanInfo.duan_orgnization.where(F_type: 1).pluck("F_name")
     # gon.hege_duan_value = [5,6,7,4,5,6,5,8,9,4,5,6]
     # gon.buhege_duan_value = [2,3,1,3,2,3,2,1,2,4,1,0]
     #第二个饼图:
     gon.dabiao_100 = {name: "考题达标率100%", value: @dabiao_100}
     gon.dabiao_80 = {name: "考题达标率80% ~ 100%", value: @dabiao_80}
     gon.dabiao_60 = {name: "考题达标率60% ~ 80%", value: @dabiao_60}
     gon.dabiao_60_below = {name: "考题达标率低于60%", value: @dabiao_60_below}
     # gon.dabiao_100 = {name: "考题达标率100%", value: 50}
     # gon.dabiao_80 = {name: "考题达标率80% ~ 100%", value: 12}
     # gon.dabiao_60 = {name: "考题达标率60% ~ 80%", value: 6}
     # gon.dabiao_60_below = {name: "考题达标率低于60%", value: 2}
     #柱状图:
     gon.dabiao_duan_key = @dabiao_duan_100.keys
     gon.dabiao_duan_100 = @dabiao_duan_100.values
     gon.dabiao_duan_80 = @dabiao_duan_80.values
     gon.dabiao_duan_60 = @dabiao_duan_60.values
     gon.dabiao_duan_60_below = @dabiao_duan_60_below.values
     # gon.dabiao_duan_key = TDuanInfo.duan_orgnization.where(F_type: 1).pluck("F_name")
     # gon.dabiao_duan_100 = @dabiao_duan_100.values
     # gon.dabiao_duan_80 = @dabiao_duan_80.values
     # gon.dabiao_duan_60 = @dabiao_duan_60.values
     # gon.dabiao_duan_60_below = @dabiao_duan_60_below.values
     #第三个饼图:
     if @program_record_detail_count.present?
       gon.program_detail_key = @program_record_detail_count.first(8).sort{|x| x[0]}
       gon.program_detail_count_a = {name: @program_record_detail_count[0][0],value: @program_record_detail_count[0][1]}
       gon.program_detail_count_b = {name: @program_record_detail_count[1][0],value: @program_record_detail_count[1][1]}
       gon.program_detail_count_c = {name: @program_record_detail_count[2][0],value: @program_record_detail_count[2][1]}
       gon.program_detail_count_d = {name: @program_record_detail_count[3][0],value: @program_record_detail_count[3][1]}
       gon.program_detail_count_e = {name: @program_record_detail_count[4][0],value: @program_record_detail_count[4][1]}
       gon.program_detail_count_f = {name: @program_record_detail_count[5][0],value: @program_record_detail_count[5][1]}
       gon.program_detail_count_g = {name: @program_record_detail_count[6][0],value: @program_record_detail_count[6][1]}
       gon.program_detail_count_h = {name: @program_record_detail_count[7][0],value: @program_record_detail_count[7][1]}
       #柱状图：
       gon.program_keys = @program_record_detail_count.sort{|x| x[0]}
       gon.program_values =@program_record_detail_count.sort{|x| x[1]}
     end
     #第四个饼图：
     if @detail_reasons_count.present?
       gon.reason_keys_8 = @detail_reasons_count.first(8).sort{|x| x[0]}
       gon.reason_value_a = {name: @detail_reasons_count[0][0], value: @detail_reasons_count[0][1]}
       gon.reason_value_b = {name: @detail_reasons_count[1][0], value: @detail_reasons_count[1][1]}
       gon.reason_value_c = {name: @detail_reasons_count[2][0], value: @detail_reasons_count[2][1]}
       gon.reason_value_d = {name: @detail_reasons_count[3][0], value: @detail_reasons_count[3][1]}
       gon.reason_value_e = {name: @detail_reasons_count[4][0], value: @detail_reasons_count[4][1]}
       gon.reason_value_f = {name: @detail_reasons_count[5][0], value: @detail_reasons_count[5][1]}
       gon.reason_value_g = {name: @detail_reasons_count[6][0], value: @detail_reasons_count[6][1]}
       gon.reason_value_h = {name: @detail_reasons_count[7][0], value: @detail_reasons_count[7][1]}
       #柱状图：
       gon.reason_keys = @detail_reasons_count.sort{|x| x[0]}
       gon.reason_values = @detail_reasons_count.sort{|x| x[1]}
     end
  end

  def duan_hege
    if params[:search].present?
      @search = TimeSearch.new(params[:search])
      @records_all = XcfRecordInfo.where("xcf_record_infos.F_begin_time between ? and ?",@search.date_from+8.hours,@search.date_to+8.hours)
    else
      @records_all = XcfRecordInfo.xcf_datetime
    end
    #下面会用到的几个查询：
    a_record_join_user = @records_all.joins(:xcf_user_infos).where("xcf_user_infos.F_duan_uuid": TDuanInfo.find_by(:F_name => params[:duan_name]).F_uuid)
    a_record_join_user_join_duan = @records_all.joins(xcf_user_infos: :t_duan_info).select("xcf_user_infos.F_id,t_duan_info.F_name").distinct
    a_record_details  = XcfRecordDetailInfo.where(F_record_uuid: a_record_join_user.pluck("xcf_record_infos.F_uuid"))
    a_detail_reasons = XcfDetailReasonInfo.where(:F_record_detail_uuid => a_record_details.pluck(:F_uuid))
    @student_all = a_record_join_user

    @record_details = a_record_details.group_by{|rd| rd.F_record_uuid}

    detail_hege = Array.new
    record_hege = Array.new
    @record_details.each do |record_uuid,record_details|
      record_details.each do |record_detail|
        if record_detail.F_score >=80
          detail_hege << 1
        else
          detail_hege << 0
        end
      end
      if !detail_hege.include?(0)
        record_hege << record_uuid
      end
    end

    @record_hege = XcfRecordInfo.where(F_uuid: record_hege)
    # 合格人数各站段哈希
    @student_hege = @record_hege.joins(xcf_user_infos: :t_duan_info).select("xcf_user_infos.F_id,t_duan_info.F_name").distinct.group("t_duan_info.F_name").count
    # 合格人数比例各站段哈希
    @student_hege_bl = Hash.new
    @student_all.keys.each do |key|
      if @student_hege[key].present?
        @student_hege_bl[key]= (@student_hege[key].to_f/@student_all[key]).round(3)*100
      else
        @student_hege_bl[key] = 0.to_f
      end
    end
  end

  def duan_dabiao

  end

  def duan_program

  end

  def duan_reason

  end








end
