class TUserInfo < ApplicationRecord
  self.table_name = "t_user_info"
  belongs_to :t_work_info 
end
