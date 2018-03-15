module ApplicationHelper

  def time_begin(params)
    if params.present?
      params.values.first
    else
      Date.today.beginning_of_month
    end
  end

  def time_end(params)
    if params.present?
      params.values.last
    else
      Date.today.end_of_month
    end
  end

end
