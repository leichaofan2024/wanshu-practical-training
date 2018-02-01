class EmployeesController < ApplicationController

  def index
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
end
