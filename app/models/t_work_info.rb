class TWorkInfo < ApplicationRecord
  self.table_name = "t_work_info"
  has_many :t_user_infoes
  has_manu :t_user_info_copies
  has_many :t_user_info_copy_copies
  has_many :t_record_infoes

end
