module WelcomeHelper

  def render_baogao_time(search,kuaizhao_time)
     if search.present?
      "#{(search.date_from.to_time - 8.hours).to_date}  ~  #{(search.date_to.to_time - 8.hours).to_date}"
     elsif kuaizhao_time.present?
       kuaizhao_time.to_time.strftime("%Y/%m/%d %I:%M %p")
     else
       "#{Time.now.beginning_of_month.to_time.strftime('%Y/%m/%d')}  ~ #{Time.now.end_of_month.to_time.strftime('%Y/%m/%d')}"
     end
  end

  def render_time_length(params)
    seconds = params % 60
    minutes = (params - seconds)/60
    time_longth = "#{minutes}分#{seconds}秒"
    return time_longth
  end
end
