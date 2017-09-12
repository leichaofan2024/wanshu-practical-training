class TProgramInfo < ApplicationRecord
  self.table_name = "t_program_info"
  has_many :t_record_detail_infoes, :class_name => "TRecordDetailInfo", :foreign_key => "F_program_id"
  has_many :t_record_infoes, :through => :t_record_detail_infoes, :source => :t_record_info
  belongs_to :t_program_type_info, :foreign_key => "F_type_id"
end
