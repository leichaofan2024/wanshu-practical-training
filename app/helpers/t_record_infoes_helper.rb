module TRecordInfoesHelper

  def time_longth(record)
    begin_time = record.F_record.split("_").last.split(".").first
    begin_time_range= begin_time.split("")
    begin_time_h = (begin_time_range[0] + begin_time_range[1]).to_i*3600
    begin_time_m = (begin_time_range[2] + begin_time_range[3]).to_i*60
    begin_time_s = (begin_time_range[4] + begin_time_range[5]).to_i
    begin_time_seconds = begin_time_h + begin_time_m + begin_time_s

    end_time = record.F_time.split(" ").last
    end_time_range = end_time.split(":")
    end_time_h = end_time_range[0].to_i*3600
    end_time_m = end_time_range[1].to_i*60
    end_time_s = end_time_range[2].to_i
    end_time_seconds = end_time_h + end_time_m + end_time_s

    time_longth_seconds = end_time_seconds - begin_time_seconds
    seconds = time_longth_seconds%60
    minute = (time_longth_seconds - seconds)/60
    time_longth = "#{minute}分#{seconds}秒"
    time_longth
  end

  def sum_time_longth(records)
    time_longth_seconds_range = Array.new
    records.each do |record|
      begin_time = record.F_record.split("_").last.split(".").first
      begin_time_range= begin_time.split("")
      begin_time_h = (begin_time_range[0] + begin_time_range[1]).to_i*3600
      begin_time_m = (begin_time_range[2] + begin_time_range[3]).to_i*60
      begin_time_s = (begin_time_range[4] + begin_time_range[5]).to_i
      begin_time_seconds = begin_time_h + begin_time_m + begin_time_s

      end_time = record.F_time.split(" ").last
      end_time_range = end_time.split(":")
      end_time_h = end_time_range[0].to_i*3600
      end_time_m = end_time_range[1].to_i*60
      end_time_s = end_time_range[2].to_i
      end_time_seconds = end_time_h + end_time_m + end_time_s

      time_longth_seconds_range << end_time_seconds - begin_time_seconds
    end
    time_longth_seconds = time_longth_seconds_range.sum
    seconds = time_longth_seconds%60
    minute = (time_longth_seconds - seconds)/60
    time_longth = "#{minute}分#{seconds}秒"
    time_longth
  end
end
