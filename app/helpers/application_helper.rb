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

end
