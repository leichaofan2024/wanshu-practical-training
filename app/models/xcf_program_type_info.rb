class XcfProgramTypeInfo < ApplicationRecord
  has_many :xcf_program_infoes, class_name: "XcfProgramInfo",foreign_key: "F_type_id"
  
end
