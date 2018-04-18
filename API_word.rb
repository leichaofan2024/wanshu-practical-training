Method: POST
API接口： http://10.64.2.108:8032/api/qjsx/data_transfer/create_data
body中的数据：

{

  "student":{                            //考生信息
      "F_uuid": string,
      "teacher_uuid": string,
      "F_id": string,                      //身份证号
      "F_type": integer,                   //0是学生,1是老师
      "F_duan_uuid": string,               //外键
      "F_station_uuid": string,            //外键
      "F_team_uuid": string,               //外键
      "F_work_uuid": string,               //外键，职位
      "record":[                             //该考生考试记录
          {
            "F_uuid": string,
            "F_score": integer,                 //本次考试得分
            "F_begin_time": datetime,           //考试开始时间
            "time_length": datetime,            //考试时长
            "F_teacher_uuid": string,           //外键本次考试老师
            "F_question_uuid": string,          //试卷名称
            "F_record":  string,                //视频回放文件名
            "F_program_detail": [
              {
                "F_program_id": integer,
                "F_reason_detail": [
                  {
                    "F_reason_id": integer
                  },
                  {
                    ...
                  },
                  ...
                ]
              },
              {
                ...
              },
              ...
            ]
          },
          {
            ...
          },
          ...
        ]
  }

}



数据格式：
{
  request {
        xcf_duan_info: {                       //站段信息
            F_uuid: string,
            F_name: string,
            F_type: integer,                   //车务的为1，直属站为2
        }
        xcf_station_info: {                    //车站信息
            F_uuid: string,
            F_name: string,
            F_duan_uuid: string,               //外键
        }
        xcf_team_info: {                       //班组信息
            F_uuid: string,
            F_name: string,
            F_station_uuid: string,            //外键
        }
        xcf_student_info: {                    //考生信息
            F_uuid: string,
            F_id: string,                      //身份证号
            F_type: integer,                   //0是学生,1是老师
            F_duan_uuid: string,               //外键
            F_station_uuid: string,            //外键
            F_team_uuid: string,               //外键
            F_work_uuid: string,               //外键，职位
        }
        xcf_work_info:{                        //职位信息
            F_uuid: string,
            F_name: string,
        }
        xcf_program_type_info:{                //考核项点的类型
            F_id: integer,
            F_name: string,
        }
        xcf_program_info: {                    //考核项点信息
            F_id: integer,
            F_name: string,
            F_type_id: integer,                //外键
        }
        xcf_reason_type_info: {                //扣分项点类型
            F_id: integer,
            F_name: string,
        }
        xcf_reason_info: {                     //扣分项点信息
            F_id: integer,
            F_reason_type_id: string,            //外键
            F_name: string,
            F_value: integer,                    //此扣分点的扣分值
        }
        xcf_detail_reason_info:{               //cxf_reason_info和xcf_record_detail_info的中间表
            F_uuid: string,
            F_record_detail_uuid: string,      //外键
            F_reson_id: integer,               //外键
            F_score: integer,                  //对应xcf_reason_info表里的扣分值
        }
        xcf_record_detail_info: {              //xcf_record_info与xcf_record_detail_info的中间表
            F_uuid: string,
            F_record_uuid: string,             //外键
            F_program_id: integer,             //外键
            F_score:  integer,                 //对应考核项点的得分
        }
        xcf_record_info:{                     //考试信息
            F_uuid: string,
            F_user_uuid: string,              //外键
            F_duan_uuid: string,              //外键
            F_station_uuid: string,           //外键
            F_team_uuid: string,              //外键
            F_work_uuid: string,              //外键
            F_begin_time: datetime,           //考试开始时间
            F_end_time: datetime,             //考试结束时间
            F_teacher_uuid: string,           //外键本次考试老师
            F_question_uuid: string,
            F_record:  string,                //视频回放文件名
        }


  }
  response{
        code: integer,                  //返回代号
        msg: string,                    //返回信息
  }
}

基础表数据：
