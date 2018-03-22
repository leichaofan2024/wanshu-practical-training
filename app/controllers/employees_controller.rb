class EmployeesController < ApplicationController
  # 这段代码是，
  # 1、如果出现了站段搜索，在此基础上，进行考试状态的搜索。
  # 2、页面的初始状态是所有的站段的数据，包含未考和已考的数据（为当月考试情况），可根据需要进行搜索。
  # ****这个暂时还没有加上时间的搜索功能

  def index
    student = TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month)
    @student_F_id = student.joins(:t_record_infoes).datetime.pluck("t_user_info.F_id").uniq
    @student_ck = student.where("t_user_info.F_id": @student_F_id).select("t_user_info.F_id, t_user_info.F_name").distinct.order("F_id DESC").page(params[:page]).per(20)
    @student_wk = student.where.not("t_user_info.F_id": @student_F_id).select("t_user_info.F_id, t_user_info.F_name").distinct.order("F_id DESC").page(params[:page]).per(20)

    @users = case params[:order]
    when 'by_student_wk'
      @student_wk
    when 'by_student_ck'
      @student_ck
    else
      TUserInfo.student_all(Time.now.beginning_of_month, Time.now.end_of_month).select("t_user_info.F_id, t_user_info.F_name").distinct.order("F_id DESC").page(params[:page]).per(20)
    end


    # @q = TUserInfo.joins(:t_station_info, :t_team_info).ransack(params[:q])
    # @users = @q.result.order("F_id DESC").page(params[:page]).per(20)
    if params[:registration_id].present?
      @users = @users.joins(:t_station_info).where('t_station_info.F_name' => params[:registration_id])
    end
  end

  def employe_record
    @employees = TUserInfo.find_by(F_name: params[:user_name])
    @employe_record = TRecordInfo.joins(:t_user_info).where('t_user_info.F_id = ?', params[:F_id])
    @student_record = @employe_record.select('t_record_info.F_time, t_record_info.F_score')
      # 这个是成绩分析的折线图
      @employe_time = []
      @student_record.pluck(:F_time).each do |t|
        @employe_time << t.to_time.strftime('%Y-%m-%d') #这个将数组中的字符串形式的时间格式，转换了一下形式，并且作为成绩的key
      end
     gon.employe_score= @student_record.pluck(:F_score)
     gon.employe_time = @employe_time

     # 这个是考试类型的饼状图分析
     m = TProgramTypeInfo.joins(t_program_infoes: {t_record_infoes: :t_user_info}).where('t_user_info.F_id = ? ', params[:F_id]).group('t_program_type_info.F_name').count
     @yjcz = { name: '应急处置', value: m['应急处置'] }
     gon.yj = @yjcz
     @zcjf = { name: '正常接发车办理科目', value: m['正常接发车办理科目'] }
     gon.zc = @zcjf
     @fzcfche = { name: '非正常发车办理科目', value: m['非正常发车办理科目'] }
     gon.fzcfche = @fzcfche
     @fzcjche = { name: '非正常接车办理科目', value: m['非正常接车办理科目'] }
     gon.fzcjche = @fzcjche

     # 这个是易错项点的饼状图分析
     record = TRecordDetailInfo.joins(t_record_info: :t_user_info).where('t_user_info.F_id = ?', params[:F_id])
     reason = TReasonInfo.joins(:t_record_detail_infoes).where("t_record_detail_info.F_uuid": record.ids).group("t_reason_info.F_name").count.sort_by { |_key, value| value }.reverse.first(4).to_h
     a,b,c,d = reason.keys
     gon.a = a
     gon.b = b
     gon.c = c
     gon.d = d
     @fl = { name: a, value: reason[a] }
     gon.fl = @fl
     @dc = { name: b, value: reason[b] }
     gon.dc = @dc
     @wt = { name: c, value: reason[c] }
     gon.wt = @wt
     @wz = { name: d, value: reason[d] }
     gon.wz = @wz

  end

  def duan_record
      @station = TStationInfo.joins(:t_user_infoes).student_all(Time.now.beginning_of_month, Time.now.end_of_month).pluck("t_station_info.F_uuid").uniq
      @duan = TDuanInfo.duan_orgnization.joins(:t_station_infoes).where("t_station_info.F_uuid": @station).group("t_duan_info.F_name").count

  end
end
