class TProgramInfo < ApplicationRecord
  self.table_name = "t_program_info"
  has_many :t_record_infoes, :class_name => "TRecordInfo", :foreign_key => "t_program_id"
end
