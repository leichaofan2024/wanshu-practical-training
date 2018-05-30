class Api::Qjsx::DataTransferController < ApiController

  def create_data
    head = request.headers["ws-xcf-api"]
    if head == "75edb54405964a0c8393ce427f5f5d5e"

      if params[:"teacher"].present?
        if params[:"teacher"][:"F_uuid"].present?
          t = XcfUserInfo.find_by(:F_uuid => params[:"teacher"][:"F_uuid"])
          if t.present?
            t.update(
               :F_name => params[:"teacher"][:"F_name"],
               :F_id => params[:"teacher"][:"F_id"],
               :F_type => 1,
               :F_duan_uuid => params[:"teacher"][:"F_duan_uuid"],
               :F_station_uuid => params[:"teacher"][:"F_station_uuid"],
               :F_work_uuid => params[:"teacher"][:"F_work_uuid"]
            )
            teacher_ret = 0
            teacher_msg = ""
            teacher = "update teacher 1条！"
          else
            XcfUserInfo.create(
              :F_uuid => params[:"teacher"][:"F_uuid"],
              :F_name => params[:"teacher"][:"F_name"],
              :F_id => params[:"teacher"][:"F_id"],
              :F_type => 1,
              :F_duan_uuid => params[:"teacher"][:"F_duan_uuid"],
              :F_station_uuid => params[:"teacher"][:"F_station_uuid"],
              :F_work_uuid => params[:"teacher"][:"F_work_uuid"]
            )
            teacher_ret = 0
            teacher_msg = ""
            teacher = "create teacher 1条！"
          end
        else
          teacher_ret = 100
          teacher_msg = "教师记录主键缺失！"
          teacher = "教师记录主键缺失，未创建！"
        end

      else
        teacher_ret = 100
        teacher_msg = "未上传教师记录！"
        teacher = "未上传教师记录！"
      end

      if params[:"student"].present?
        if params[:"student"][:"F_uuid"].present?
          s = XcfUserInfo.find_by(:F_uuid => params[:"student"][:"F_uuid"])
          if s.present?
            s.update(
              F_name: params[:"student"][:"F_name"],
              F_id: params[:"student"][:"F_id"],
              F_type: 0,
              F_duan_uuid: params[:"student"][:"F_duan_uuid"],
              F_station_uuid: params[:"student"][:"F_station_uuid"],
              F_work_uuid: params[:"student"][:"F_work_uuid"]
            )
            student_ret = 0
            student_msg = ""
            student = "update student 1条！"
          else
            XcfUserInfo.create(
              F_uuid:         params[:"student"][:"F_uuid"],
              F_name:         params[:"student"][:"F_name"],
              F_id:           params[:"student"][:"F_id"],
              F_type:         0,
              F_duan_uuid:    params[:"student"][:"F_duan_uuid"],
              F_station_uuid: params[:"student"][:"F_station_uuid"],
              F_work_uuid:    params[:"student"][:"F_work_uuid"]
            )
            student_ret = 0
            student_msg = ""
            student = "create student 1条！"
          end

        else
          student_ret = 100
          student_msg = "考生记录主键缺失！"
          student = "create student 0条；"
          record_ret = 0
          record_msg = ""
          record = "create record 0条；"
          program_ret = 0
          program_msg = ""
          program = "create program 0条；"
          reason_ret = 0
          reason_msg = ""
          reason = "create reason 0条；"
        end
      else
        student_ret = 100
        student_msg = "未上传考生信息！"
        student = "create student 0条；"
        record_ret = 0
        record_msg = "未上传考试记录！"
        record = "create record 0条；"
        program_ret = 0
        program_msg = "未上传考核项点详情！"
        program = "create program 0条；"
        reason_ret = 0
        reason_msg = "未上传扣分详情！"
        reason = "create reason 0条；"
      end

      if params[:"record"].present?
        r = params[:"record"]
          r1=XcfRecordInfo.find_by(:F_uuid => r[:"F_uuid"])
          if r1.present?
            XcfRecordInfo.update(
              F_user_uuid:     r[:"F_user_uuid"],
              F_location:      r[:"F_location"],
              F_score:         r[:"Fscore"],
              F_begin_time:    r[:"F_begin_time"],
              time_length:     r[:"time_length"],
              F_teacher_uuid:  r[:"F_teacher_uuid"],
              F_question_name: r[:"F_question_name"],
              F_pre_work_uuid: params[:"student"][:"F_pre_work_uuid"],
              F_bs_name:       params[:"student"][:"F_bs_name"]
            )
            record_ret = 0
            record_msg = ""
            record = "update record 1条；"

          else
            XcfRecordInfo.create(
              F_uuid:          r[:"F_uuid"],
              F_user_uuid:     r[:"F_user_uuid"],
              F_location:      r[:"F_location"],
              F_score:         r[:"Fscore"],
              F_begin_time:    r[:"F_begin_time"],
              time_length:     r[:"time_length"],
              F_teacher_uuid:  r[:"F_teacher_uuid"],
              F_question_name: r[:"F_question_name"],
              F_pre_work_uuid: params[:"student"][:"F_pre_work_uuid"],
              F_bs_name:       params[:"student"][:"F_bs_name"]
            )
            record_ret = 0
            record_msg = ""
            record = "create record 1条；"
          end
          pg = r[:"F_program_detail"]
          n = pg.size
          if pg.present?
            pg.each do |pg1|
              record_detail_info_uuid = SecureRandom.hex
              XcfRecordDetailInfo.create(
                F_uuid: record_detail_info_uuid,
                F_record_uuid: r[:"F_uuid"],
                F_program_id: pg1[:"F_program_id"],
                F_score:      pg1[:"F_score"]
              )
              if pg1[:"F_reason_detail"].present?
                x = pg1[:"F_reason_detail"].size
                pg1[:"F_reason_detail"].each do |detail_reason|
                  XcfDetailReasonInfo.create(
                    F_uuid:                 SecureRandom.hex,
                    F_record_detail_uuid:   record_detail_info_uuid,
                    F_reason_id:            detail_reason[:"F_reason_id"],
                    F_time:                 detail_reason[:"F_time"],
                    F_score:                XcfReasonInfo.find_by(:F_id => detail_reason[:"F_reason_id"]).F_value
                  )
                end
                reason_ret = 0
                reason_msg = ""
                reason = "create reason #{n*x}条；"
              else
                reason_ret = 0
                reason_msg = ""
                reason = "create reason 0条；"
              end
            end
            program_ret = 0
            program_msg = ""
            program = "create program #{n}条；"
          else
            program_ret = 0
            program_msg = ""
            program = "create program 0条；"
          end

      else
        record_ret = 0
        record_msg = ""
        record = "create record 0条；"
        program_ret = 0
        program_msg = ""
        program = "create program 0条；"
        reason_ret = 0
        reason_msg = ""
        reason = "create reason 0条；"
      end

      render :json => {
        "ret" => teacher_ret + student_ret + record_ret + program_ret + reason_ret ,
        "msg" => teacher_msg + student_msg + record_msg + program_msg + reason_msg,
        "data" => teacher + student + record + program + reason
      }
    else
      render :json => {
        "ret" => 1,
        "msg" => "token无效",
        "data" => ""
      }
    end
  end






  def data_test

    head = request.headers["ws-xcf-api"]
    if head == "75edb54405964a0c8393ce427f5f5d5e"

      if params[:"teacher"].present?
        if params[:"teacher"][:"F_uuid"].present?
          t = XcfUserInfo.find_by(:F_uuid => params[:"teacher"][:"F_uuid"])
          if t.present?

            teacher_ret = 0
            teacher_msg = ""
            teacher = "update teacher 1条！"
          else

            teacher_ret = 0
            teacher_msg = ""
            teacher = "create teacher 1条！"
          end
        else
          teacher_ret = 100
          teacher_msg = "教师记录主键缺失！"
          teacher = "教师记录主键缺失，未创建！"
        end

      else
        teacher_ret = 100
        teacher_msg = "未上传教师记录！"
        teacher = "未上传教师记录！"
      end

      if params[:"student"].present?
        if params[:"student"][:"F_uuid"].present?
          s = XcfUserInfo.find_by(:F_uuid => params[:"student"][:"F_uuid"])
          if s.present?

            student_ret = 0
            student_msg = ""
            student = "update student 1条！"
          else

            student_ret = 0
            student_msg = ""
            student = "create student 1条！"
          end

        else
          student_ret = 100
          student_msg = "考生记录主键缺失！"
          student = "create student 0条；"
          record_ret = 0
          record_msg = ""
          record = "create record 0条；"
          program_ret = 0
          program_msg = ""
          program = "create program 0条；"
          reason_ret = 0
          reason_msg = ""
          reason = "create reason 0条；"
        end
      else
        student_ret = 100
        student_msg = "未上传考生信息！"
        student = "create student 0条；"
        record_ret = 0
        record_msg = "未上传考试记录！"
        record = "create record 0条；"
        program_ret = 0
        program_msg = "未上传考核项点详情！"
        program = "create program 0条；"
        reason_ret = 0
        reason_msg = "未上传扣分详情！"
        reason = "create reason 0条；"
      end

      if params[:"record"].present?
        r = params[:"record"]
          r1=XcfRecordInfo.find_by(:F_uuid => r[:"F_uuid"])
          if r1.present?

            record_ret = 0
            record_msg = ""
            record = "update record 1条；"

          else

            record_ret = 0
            record_msg = ""
            record = "create record 1条；"
          end
          pg = r[:"F_program_detail"]
          n = pg.size
          if pg.present?
            pg.each do |pg1|

              if pg1[:"F_reason_detail"].present?
                x = pg1[:"F_reason_detail"].size

                reason_ret = 0
                reason_msg = ""
                reason = "create reason #{n*x}条；"
              else
                reason_ret = 0
                reason_msg = ""
                reason = "create reason 0条；"
              end
            end
            program_ret = 0
            program_msg = ""
            program = "create program #{n}条；"
          else
            program_ret = 0
            program_msg = ""
            program = "create program 0条；"
          end

      else
        record_ret = 0
        record_msg = ""
        record = "create record 0条；"
        program_ret = 0
        program_msg = ""
        program = "create program 0条；"
        reason_ret = 0
        reason_msg = ""
        reason = "create reason 0条；"
      end

      render :json => {
        "ret" => teacher_ret + student_ret + record_ret + program_ret + reason_ret ,
        "msg" => teacher_msg + student_msg + record_msg + program_msg + reason_msg,
        "data" => teacher + student + record + program + reason
      }
    else
      render :json => {
        "ret" => 1,
        "msg" => "token无效",
        "data" => ""
      }
    end
  end

end
