class TRecordInfo < ApplicationRecord
  self.table_name = "t_record_info"
  belongs_to :t_work_info
  belongs_to :t_duan_info,:class_name =>"TDuanInfo", :foreign_key => "F_duan_uuid"
  belongs_to :t_user_info,:foreign_key => "F_user_uuid"
end
