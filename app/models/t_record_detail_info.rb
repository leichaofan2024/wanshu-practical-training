class TRecordDetailInfo < ApplicationRecord
  self.table_name ="t_record_detail_info"
  belongs_to :t_program_info, :class_name => "TProgramInfo", :foreign_key => "F_program_id"
  has_many :t_detail_reason_infoes, :class_name => "TDetailReasonInfo", :foreign_key => "F_record_detail_uuid"
  belongs_to :t_record_info, :class_name => "TRecordInfo", :foreign_key => "F_record_uuid" 

end
