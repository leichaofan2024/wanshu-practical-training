class TUserInfo < ApplicationRecord
  self.table_name = "t_user_info"
  belongs_to :t_work_info
  belongs_to :t_duan_info,:class_name =>"TDuanInfo", :foreign_key => "F_duan_uuid"
  has_many :t_record_infoes, :foreign_key => "F_user_uuid"


end
