class TReasonInfo < ApplicationRecord
  self.table_name = "t_reason_info"
  has_many :t_detail_reason_infoes,:class_name => "TDetailReasonInfo", :foreign_key => "F_reason_id"
  has_many :t_record_detail_infoes, :through => :t_detail_reason_infoes, source: :t_record_detail_info





end
