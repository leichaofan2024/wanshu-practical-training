class TUserInfoCopyCopy < ApplicationRecord
  self.table_name = "t_user_info_copy_copy"
  belongs_to :t_work_info 
end
