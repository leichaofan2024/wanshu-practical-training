class TDetailReasonInfo < ApplicationRecord
  self.table_name = "t_detail_reason_info"
  belongs_to :t_record_detail_info, :class_name => "TRecordDetailInfo",:foreign_key => "F_record_detail_uuid"
  belongs_to :t_reason_info, :class_name => "TReasonInfo", :foreign_key => "F_reason_id"
end
