module ApplicationHelper

  def time_begin(params)
    if params.present?
      if params[:date_from].present?
        params[:date_from].to_date
      elsif params[:date_from].blank? && params[:date_to].present?
        params[:date_to].to_date.beginning_of_month.to_date
      elsif params[:date_from].blank? && params[:date_to].blank?
        Date.today.beginning_of_month
      end
    else
        Date.today.beginning_of_month
    end
  end

  def time_end(params)
    if params.present?
      if params[:date_to].present?
        params[:date_to].to_date
      elsif params[:date_from].present? && params[:date_to].blank?
        params[:date_from].to_date.end_of_month.to_date
      elsif params[:date_from].blank? && params[:date_to].blank?
        Date.today.end_of_month
      end
    else
        Date.today.end_of_month
    end
  end

  def render_student_status(student,time_interval,station_name)
    if student.status == "退休"
      return student.status
    elsif student.status == "调离"
      "点击修复"
    else
      a = TVacationInfo.student_transfer(time_interval[:date_from],time_interval[:date_to])
      b = TVacationInfo.student_long_vacation(time_interval[:date_from],time_interval[:date_to])
      c = TVacationInfo.student_short_vacation(time_interval[:date_from],time_interval[:date_to])
      if a.include?(student.F_uuid)
        return "调离"
      elsif b.include?(student.F_id)
        return "长假"
      elsif c.include?(student.F_id)
        return "短假"
      else
        return "在职"
      end
    end
  end

end
