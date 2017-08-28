class TRecordDetailInfo < ApplicationRecord
  self.table_name ="t_record_detail_info"
  belongs_to :t_program_info, :class_name => "TProgramInfo", :foreign_key => "F_program_id"
  has_many :t_detail_reason_infoes, :class_name => "TDetailReasonInfo", :foreign_key => "F_record_detail_uuid"

  scope :record_type_1,-> { where(:F_program_id => TProgramInfo.where(:F_type_id => TProgramTypeInfo.all[0]))}
  scope :record_type_2,-> { where(:F_program_id => TProgramInfo.where(:F_type_id => TProgramTypeInfo.all[1]))}
  scope :record_type_3,-> { where(:F_program_id => TProgramInfo.where(:F_type_id => TProgramTypeInfo.all[2]))}
  scope :record_type_4,-> { where(:F_program_id => TProgramInfo.where(:F_type_id => TProgramTypeInfo.all[3]))}
end
