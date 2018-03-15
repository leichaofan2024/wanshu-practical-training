class TProgramTypeInfo < ApplicationRecord
  self.table_name = "t_program_type_info"
  has_many :t_program_infoes, class_name: "TProgramInfo", :foreign_key => "F_type_id"
end
