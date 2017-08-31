class TReasonInfo < ApplicationRecord
  self.table_name = "t_reason_info"
  has_many :t_detail_reason_infoes,:class_name => "TDetailReasonInfo", :foreign_key => "F_reason_id"






end
