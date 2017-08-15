class TUserInfoCopy <ApplicationRecord
  self.table_name = "t_user_info_copy"
  belongs_to :t_work_info 
end
