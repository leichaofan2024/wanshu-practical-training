class TUserInfoCopy <ApplicationRecord
  self.table_name = "t_user_info_copy"
  belongs_to :t_work_info
  belongs_to :t_duan_info, :class_name => "TDuanInfo",:foreign_key => "F_duan_uuid"
end
