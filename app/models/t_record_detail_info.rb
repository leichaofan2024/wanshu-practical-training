class TRecordDetailInfo < ApplicationRecord
  self.table_name ="t_record_detail_info"
  belongs_to :t_program_info, :class_name => "TProgramInfo", :foreign_key => "F_program_id"
end
