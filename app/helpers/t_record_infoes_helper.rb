module TRecordInfoesHelper

  def time_longth(record)
    seconds = record.time_length % 60
    minutes = (record.time_length - seconds)/60
    time_longth = "#{minutes}分#{seconds}秒"
    return time_longth
  end

  def sum_time_longth(records)

    time_longth_seconds = records.sum(:time_length)
    seconds = time_longth_seconds%60
    minutes = (time_longth_seconds - seconds)/60
    time_longth = "#{minutes}分#{seconds}秒"
    time_longth
  end
end
