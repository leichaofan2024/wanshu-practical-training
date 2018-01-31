class EmployeesController < ApplicationController

  def index
    @employees = TUserInfo.find_by(F_name: params[:user_name])
    @employe_record = TRecordInfo.joins(:t_user_info).where('t_user_info.F_id = ?', params[:F_id])
    @student_record = @employe_record.select('t_record_info.F_time, t_record_info.F_score')
      @employe_score_key = []
      @student_record.pluck(:F_time).each do |t|
        @employe_score_key << t.to_time.strftime('%Y-%m-%d')
      end

     gon.employe_score= @student_record.pluck(:F_score)
     gon.employe_score_key = @employe_score_key
  end
end
